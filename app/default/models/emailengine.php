<?php
class EmailEngine extends Model
{
    
    function send($to='',$name='',$subject='',$content = '',$attachment=false,$cc = false,$bcc = false)
    {
        try {                               
                                
            App::vendor('phpmailer/PHPMailerAutoload');
            //PHPMailer Object
            $mail = new PHPMailer(true);
            
            $mail->isSMTP(); // tell to use smtp
            $mail->CharSet = "utf-8"; // set charset to utf8
            $mail->SMTPAuth = true;  // use smpt auth
            $mail->SMTPSecure = Config::get('MAIL_ENCRYPTION');; // or ssl
            $mail->Host = Config::get('MAIL_HOST');
            $mail->Port = Config::get('MAIL_PORT'); // most likely something different for you. This is the mailtrap.io port i use for testing. 
            $mail->Username = Config::get('MAIL_USERNAME');
            $mail->Password = Config::get('MAIL_PASSWORD');
            $mail->setFrom(Option::get('email_from'), Option::get('email_from_name'));
            $mail->addAddress($to, $name);
            
            //$mail->addCC(Option::get('email_cc'));
            if($cc) {
                foreach($cc as $ccc) {
                    $mail->addCC($ccc['email'],$ccc['name']);
                }
            }
            $mail->addBCC(Option::get('email_bcc'));
            if($bcc) {
                foreach($bcc as $bccc) {
                    $mail->addBCC($bccc['email'],$bccc['name']);
                }
            }
            $mail->Subject = $subject;
            $mail->MsgHTML($content);
            
            
            if($attachment) {           
                foreach($attachment as $att) {
                    $mail->AddAttachment($att['path'],$att['name']);
                }
            }
            
            if (!$mail->send()) {
                return false;
            } else {
                return true;
            }
        } catch(phpmailerException $e) {
            echo $e->getMessage();            
        }
    }  
}