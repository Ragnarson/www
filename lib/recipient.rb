class Recipient < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, format: /\A.*@.*\z/

  def send_pdf
    body = <<-eos
Hi there,

As you requested, we have sent you a document which will helps us with:

* getting to know each other
* setting expectations
* starting the cooperation

Feel free to reply to this email if you want to get in touch with us.

Regards
--
Ragnarson Sp. z o. o.
http://ragnarson.com/, biz@ragnarson.com
KRS: 0000365781 NIP:7272768902 REGON: 100960955
eos
    pdf = File.read("./public/how-do-we-work-at-ragnarson.pdf")

    Pony.mail(
      charset: 'UTF-8',
      from: 'Ragnarson (Ruby developers) <biz@ragnarson.com>',
      to: email,
      subject: "Transform your idea into a working product",
      body: body,
      attachments: {
        "how-do-we-work-at-ragnarson.pdf" => pdf
      }
    )
  end
end
