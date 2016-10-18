;(function($) {
    'use strict';
    var undefined;
    var slice = Array.prototype.slice;
    var isFunction = $.isFunction;
    var isString = function(obj) {
        return typeof obj === 'string';
    };
    var isObject = function(obj) {
        return typeof obj === 'object';
    };
    var returnFalse = function() {
        return false;
    };

    function calculateAngle(x1, x2, y1, y2) {
        var x = x1 - x2;
        var y = y1 - y2;
        var r = Math.atan2(y, x);
        var angle = Math.round(r * 180 / Math.PI);
        if (angle < 0) {
            angle = 360 - Math.abs(angle);
        }
        return angle;
    }

    function calculateDirection(x1, x2, y1, y2) {
        var angle = calculateAngle(x1, x2, y1, y2);
        if ((angle <= 45 && angle >= 0) || (angle <= 360 && angle >= 315)) {
            return 'left';
        } else if (angle >= 135 && angle <= 225) {
            return 'right';
        } else if (angle > 45 && angle < 135) {
            return 'down';
        } else {
            return 'up';
        }
    }

    var PLUGIN_NS = '_TOUCH_';
    var PLUGIN_EVENT_NS = '.' + PLUGIN_NS + 'EVENT_';
    var SUPPORTS_TOUCH = 'ontouchstart' in window;
    var SUPPORTS_POINTER_IE10 = window.navigator.msPointerEnabled && !window.navigator.pointerEnabled;
    var SUPPORTS_POINTER = window.navigator.pointerEnabled || window.navigator.msPointerEnabled;
    var useTouchEvents = SUPPORTS_TOUCH || SUPPORTS_POINTER;
    var START_EV = (useTouchEvents ? (SUPPORTS_POINTER ? (SUPPORTS_POINTER_IE10 ? 'MSPointerDown' : 'pointerdown') : 'touchstart') : 'mousedown') + PLUGIN_EVENT_NS;
    var MOVE_EV = (useTouchEvents ? (SUPPORTS_POINTER ? (SUPPORTS_POINTER_IE10 ? 'MSPointerMove' : 'pointermove') : 'touchmove') : 'mousemove') + PLUGIN_EVENT_NS;
    var END_EV = (useTouchEvents ? (SUPPORTS_POINTER ? (SUPPORTS_POINTER_IE10 ? 'MSPointerUp' : 'pointerup') : 'touchend') : 'mouseup') + PLUGIN_EVENT_NS;
    var CANCEL_EV = (SUPPORTS_POINTER ? (SUPPORTS_POINTER_IE10 ? 'MSPointerCancel' : 'pointercancel') : 'touchcancel') + PLUGIN_EVENT_NS;

    var defaults = {
        fingers: 1,
        threshold: 75,
        longTapThreshold: 500,
        doubleTapThreshold: 200,
        excludedElements: 'label, button, input, select, textarea, .noTouch',
        pageScroll: true,
        swipeMove: null
    };

    var _cache = {};
    $.fn.touch = function(options) {
        var opts = {};
        var cid;
        if (isObject(options)) {
           $.extend(opts, $.fn.touch.defaults, options);
            this.each(function () {
                cid = _tid;
                _cache[cid] = opts;
                this._cid = cid;
                _tid++;
            });
        }
        return this;
    };

    $.fn.touch.defaults = defaults;

    var singleTapTimeout = null;
    var holdTimeout = null;

    var _tid = 1;
    var handlers = {};

    function isTouchEvent(event) {
        return /^(tap|doubleTap|longTap|swipe|swipeLeft|swipeRight|swipeUp|swipeDown)$/.test(parse(event).e);
    }

    function tid(element) {
        return element._tid || (element._tid = _tid++);
    }

    function parse(event) {
        var parts = ('' + event).split('.')
        return {
            e: parts[0],
            ns: parts.slice(1).sort().join(' ')
        }
    }

    function matcherFor(ns) {
        return new RegExp('(?:^| )' + ns.replace(' ', ' .* ?') + '(?: |$)');
    }

    function removeTouch(element, event, selector, callback) {
        var set = handlers[tid(element)];
        var len = set.length;
        if (!(Array.isArray(set) && len)) {
            return;
        }

        if (!isString(selector) && !isFunction(callback) && callback !== false) {
            callback = selector;
            selector = undefined;
        }
        if (callback === false) {
            callback = returnFalse;
        }

        event = parse(event);
        if (event.ns) {
            var matcher = matcherFor(event.ns);
        }

        var i = 0;
        for (i; i < len;) {
            var handler = set[i];
            if (handler && handler.e === event.e && (!event.ns || matcher.test(handler.ns)) && (!callback || tid(handler.fn) === tid(callback)) && (!selector || handler.sel == selector)) {
                set.splice(i, 1);
                len--;
            } else {
                i++;
            }
        }
    }

    function Touch(element, event, selector, data, callback) {
        if (!isString(selector) && !isFunction(callback) && callback !== false) {
            callback = data;
            data = selector;
            selector = undefined;
        }
        if (callback === undefined || data === false) {
            callback = data;
            data = undefined;
        }
        if (callback === false) {
            callback = returnFalse;
        }

        var handler = parse(event);
        handler.fn = callback;
        handler.callback = callback;

        if (selector) {
            handler.callback = function(e) {
                var match = $(e.target).closest(selector, element).get(0);
                if (match && match !== element) {
                    return callback.apply(match, arguments);
                }
            };
            handler.sel = selector;
        }

        var hasTouch = !!element._tid;

        var id = tid(element);
        var set = (handlers[id] || (handlers[id] = []));
        set.push(handler);

        if (isObject(Touch.instance) && hasTouch) {
            return Touch.instance;
        }

        this.handler = set;
        this.el = element;
        this.$el = $(element);
        this.options = _cache[element._cid] || $.fn.touch.defaults;
        this.$el.on(START_EV, $.proxy(this.touchStart, this)).on(CANCEL_EV, $.proxy(this.touchCancel, this));

        Touch.instance = this;
    }

    Touch.prototype = {
        _isTouch: false,
        _doubleTapTime: 0,
        touch: {},
        touchStart: function(e) {
            var _this = this;
            var options = this.options;
            if (this._isTouch || !this.handler.length || $(e.target).closest(options.excludedElements, this.el).length) {
                return;
            }

            this._status = 'start';

            var touches = e.touches;
            var evt = touches ? touches[0] : e;
            var fingerCount = 0;

            if (touches) {
                fingerCount = touches.length;
            }

            if (!options.pageScroll || !touches) {
                e.preventDefault();
            }

            this.createTouchData(evt);

            if (!touches || (fingerCount === options.fingers || options.fingers === 'all')) {
                if (this.hasEvent('longTap')) {
                    holdTimeout = setTimeout(function() {
                        _this.trigger('longTap', e);
                    }, options.longTapThreshold);
                }
                this.setTouchProgress(true);
            } else {
                this._status = 'cancel';
                this.triggerHandler(e);
                return false;
            }
        },
        touchMove: function(e) {
            if (this._status === 'end' || this._status === 'cancel') {
                return;
            }
            if (this.hasEvent('longTap')) {
                holdTimeout && clearTimeout(holdTimeout);
                holdTimeout = null;
                return;
            }
            if (!this.options.pageScroll) {
                e.preventDefault();
            }
            var touches = e.touches;
            var evt = touches ? touches[0] : e;
            this.updateTouchData(evt);
            this.touch.now = e.timeStamp;
            if (this.hasSwipe()) {
                this._status = 'move';
                if (this.isSwipe()) {
                    e.preventDefault();
                }
                if (isFunction(this.options.swipeMove)) {
                    var direction = this.getDirection();
                    var distance = Math.abs((direction === 'up' || direction === 'down') ? this.touch.y2 - this.touch.y1 : this.touch.x2 - this.touch.x1);
                    var duration = this.getDuration();
                    this.$el.trigger('swipeMove', [direction, distance, duration, e]);
                    this.options.swipeMove.call(this.el, e, direction, distance, duration);
                }
            } else {
                this._status = 'cancel';
                this.triggerHandler(e);
            }
        },
        touchEnd: function(e) {
            if (e.touches && e.touches.length) {
                return true;
            }
            this.touch.now = e.timeStamp;
            this._status = this._status === 'move' ? 'end' : 'cancel';

            this.triggerHandler(e);

            this.touchCancel();
        },
        touchCancel: function() {
            this.touch = {};
            this.setTouchProgress(false);
        },
        triggerHandler: function(e) {
            var _this = this;
            if (this._status === 'end' && this.isSwipe() && this.hasSwipe()) {
                e.preventDefault();
                var direction = this.getDirection();
                this.trigger($.camelCase('swipe-' + direction), e);
                if (this.hasEvent('swipe')) {
                    this.trigger('swipe', e, direction);
                }
            } else if (this._status === 'cancel' || this._status === 'end') {
                holdTimeout && clearTimeout(holdTimeout);
                singleTapTimeout && clearTimeout(singleTapTimeout);
                holdTimeout = singleTapTimeout = null;

                if (this.isDoubleTap()) {
                    this._doubleTapTime = null;
                    this.trigger('doubleTap', e);
                } else if (this.isLongTap()) {
                    this._doubleTapTime = null;
                    this.trigger('longTap', e);
                } else if (this.isTap()) {
                    if (this.hasEvent('doubleTap') && !this.isDoubleTap()) {
                        this._doubleTapTime = this.touch.now;
                        singleTapTimeout = setTimeout(function() {
                            _this._doubleTapTime = null;
                        }, this.options.doubleTapThreshold);
                    } else {
                        this._doubleTapTime = null;
                    }
                    if (this.hasEvent('tap')) {
                        this.trigger('tap', e);
                    }
                }
                this.touchCancel();
            }
        },
        trigger: function(event, evt) {
            var _this = this;
            var args = slice.call(arguments, 1);
            this.$el.trigger(event, evt);
            this.handler.forEach(function (handler) {
                handler && handler.e === event && handler.callback.apply(_this.el, args);
            });
        },
        hasEvent: function(event) {
            var handler = this.handler;
            var ret = false;
            var reg = new RegExp('^(' + event + ')$');
            for (var i = handler.length - 1; i >= 0; i--) {
                if (reg.test(handler[i].e)) {
                    ret = true;
                    break;
                }
            }
            return ret;
        },
        hasSwipe: function() {
            return this.hasEvent('swipe|swipeLeft|swipeRight|swipeUp|swipeDown');
        },
        isSwipe: function() {
            return this.getDistance() >= this.options.threshold;
        },
        isDoubleTap: function() {
            if (this._doubleTapTime === null) {
                return false;
            }
            return this.hasEvent('doubleTap') && ((this.touch.now - this._doubleTapTime) <= this.options.doubleTapThreshold);
        },
        hasTap: function() {
            return this.hasEvent('tap|doubleTap');
        },
        isTap: function() {
            return this.hasTap() && this.getDistance() < this.options.threshold;
        },
        isLongTap: function() {
            return this.hasEvent('longTap') && this.getDuration() > this.options.longTapThreshold && this.getDistance() < 10;
        },
        createTouchData: function(e) {
            var touch = {};
            touch.x1 = touch.x2 = e.pageX || e.clientX;
            touch.y1 = touch.y2 = e.pageY || e.clientY;
            touch.now = touch.last = new Date().getTime();
            this.touch = touch;
            return touch;
        },
        updateTouchData: function(e) {
            this.touch.x2 = e.pageX || e.clientX;
            this.touch.y2 = e.pageY || e.clientY;
        },
        getDirection: function() {
            var touch = this.touch;
            return calculateDirection(touch.x1, touch.x2, touch.y1, touch.y2);
        },
        getDistance: function() {
            var touch = this.touch;
            return Math.round(Math.sqrt(Math.pow(touch.x2 - touch.x1, 2) + Math.pow(touch.y2 - touch.y1, 2)));
        },
        getDuration: function() {
            var touch = this.touch;
            return touch.now - touch.last;
        },
        setTouchProgress: function(isTouch) {
            if (isTouch) {
                this.$el.on(MOVE_EV, $.proxy(this.touchMove, this)).on(END_EV, $.proxy(this.touchEnd, this));
            } else {
                this.$el.off(MOVE_EV, $.proxy(this.touchMove, this)).off(END_EV, $.proxy(this.touchEnd, this));
            }
            this._isTouch = isTouch;
        }
    };

    var _on = $.fn.on;
    var _off = $.fn.off;

    $.fn.on = function(event, selector, data, callback) {
        if (event && !isString(event)) {
            return _on.apply(this, arguments);
        }

        if (isTouchEvent(event)) {
            this.each(function() {
                new Touch(this, event, selector, data, callback);
            });
            return this;
        } else {
            return _on.apply(this, arguments);
        }
    };

    $.fn.off = function(event, selector, callback) {
        if (event && !isString(event)) {
            return _off.apply(this, arguments);
        }

        if (isTouchEvent(event)) {
            this.each(function() {
                removeTouch(this, event, selector, callback);
            });
            return this;
        } else {
            if (!event) {
                this.each(function() {
                    handlers[tid(this)] = [];
                });
            }
            return _off.apply(this, arguments);
        }
    };

})(window.Zepto || window.jQuery);
