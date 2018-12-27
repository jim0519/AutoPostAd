using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ActiveUp.Net.Mail;
using System.Net.Mail;
using System.Net;

namespace AutoReplyMail
{
    class Program
    {
        static void Main(string[] args)
        {
            //TestPop3("pop.mail.yahoo.com", 995, "JustNotLuck17@yahoo.com", "Gosou-1810");
            TestPop3("pop.mail.yahoo.com", 995, "LeiXi2003@yahoo.com.au", "MySixthLove20150501");
            //TestImapYahoo();
            //TestImapGmail();
        }

        public static void TestImapGmail()
        {
            Imap4Client imap = new Imap4Client();
            imap.ConnectSsl("imap.gmail.com", 993);
            imap.Login("gdutjim@gmail.com", "Marjoriewei-0310");
            imap.Command("capability");

            Mailbox inbox = imap.SelectMailbox("inbox");
            //int[] ids = inbox.Search("FROM users.gumtree.com.au");
            //int[] ids = inbox.Search("users.gumtree.com.au");
            int[] ids = inbox.Search("Unseen");
            for (int i = ids.Count()-1; i >ids.Count()-1- 10; i--)
            {
                Header msgHeader = inbox.Fetch.HeaderObject(ids[i]);
                Console.WriteLine(msgHeader.Subject);
                FlagCollection flags = new FlagCollection();
                flags.Add("Seen");
                inbox.AddFlags(ids[i], flags);
            }
            Console.ReadLine();
            //imap.Check
            //FlagCollection flags = new FlagCollection();
            //flags.Add("Unseen");
            //inbox.AddFlags(ids[0], flags);
        }

        public static void TestImapYahoo()
        {
            Imap4Client imap = new Imap4Client();
            imap.ConnectSsl("imap.mail.yahoo.com", 993);
            imap.LoginFast("LeiXi2003@yahoo.com.au", "MySixthLove20150501");
            imap.Command("capability");

            Mailbox inbox = imap.SelectMailbox("inbox");
            //int[] ids = inbox.Search("FROM users.gumtree.com.au");
            //int[] ids = inbox.Search("users.gumtree.com.au");
            int[] ids = inbox.Search("Unseen");
            for (int i = ids.Count() - 1; i > ids.Count() - 1 - 10; i--)
            {
                Header msgHeader = inbox.Fetch.HeaderObject(ids[i]);
                Console.WriteLine(msgHeader.Subject);
                FlagCollection flags = new FlagCollection();
                flags.Add("Seen");
                inbox.AddFlags(ids[i], flags);
            }
            Console.ReadLine();
            //imap.Check
            //FlagCollection flags = new FlagCollection();
            //flags.Add("Unseen");
            //inbox.AddFlags(ids[0], flags);
        }

        public static void TestPop3(string host, int port, string user, string password)
        {
            try
            {
                Pop3Client pop3 = new Pop3Client();
                //pop3.Connect(host, port);
                pop3.ConnectSsl(host, port);
                pop3.Login(user, password);
                var lastReadUniqueID = GetLastUniqueID();
                //var uniqueIDs = pop3.GetUniqueIds().OrderByDescending(u => u.Index);
                //var lastGetIndex = pop3.GetMessageIndex("AAt3w0MAFUX2V86OGwA+gIYM9nw");
                var uniqueIDs = pop3.GetUniqueIds().OrderByDescending(u => u.Index).TakeWhile(uid => uid.Index > 11200);
                var listMessageBody = new List<Message>();
                foreach (var uniqueID in uniqueIDs)
                {
                    var index = uniqueID.Index;
                    var id = uniqueID.UniqueId;
                    listMessageBody.Add(pop3.RetrieveMessageObject(index));
                    //var body = message.BodyHtml.Text;
                    //Console.Write(body);
                    //Console.Read();
                }

                var selectedMessages = listMessageBody.Where(m => m.From.Email.Contains("users.gumtree.com.au"));

                //var uniqueIDsOrdered=uniqueIDs.OrderByDescending(u => u.Index);
                foreach (var m in selectedMessages)
                {
                    Console.Write(m.BodyText.TextStripped);
                    Console.Read();
                }
            }
            catch (Exception ex)
            {

            }
        }

        private static object GetLastUniqueID()
        {
            return new Pop3Client.PopServerUniqueId() { Index=1000,UniqueId="" };
        }

        public static void TestSmtp()
        {
            try
            {
                //var smpt = new SmtpClient();
                //smpt.ConnectSsl("smtp.mail.yahoo.com",465);
                //smpt.Authenticate("LeiXi2003@yahoo.com.au", "MySixthLove20150501",SaslMechanism.Login);
                //smpt.

                var msg = new Message();
                msg.From.Email = "LeiXi2003@yahoo.com.au";
                msg.To.Add("gdutjim@gmail.com");
                msg.Subject = "Test Yahoo Smpt Sending Mail";
                msg.BodyText.Text = @"Program get gumtree email from yahoo via pop3, make it as local mail and send it to advertiser via local mail server, 
save gumtree customer email address, mail unique ID(mail server provider) and sent mail unique ID(local mail server); 
Advertiser reply email via local mail server, program get local server new reply mail, find back the mail unique ID(local mail server) and gumtree customer email address, 
send replied mail via mail server provider";
                var guid=Guid.NewGuid();
                msg.MessageId = guid.ToString();
                msg.HeaderFields["X-Mailer"]="Random X Mailer";

                ActiveUp.Net.Mail.SmtpClient.SendSsl(msg, "smtp.mail.yahoo.com", 465, "LeiXi2003@yahoo.com.au", "MySixthLove20150501", SaslMechanism.Login);
                
                var msgID = msg.MessageId;

//                var subject = "Test Yahoo Smpt Sending Mail";
//                var body = @"Program get gumtree email from yahoo via pop3, make it as local mail and send it to advertiser via local mail server, 
//save gumtree customer email address, mail unique ID(mail server provider) and sent mail unique ID(local mail server); 
//Advertiser reply email via local mail server, program get local server new reply mail, find back the mail unique ID(local mail server) and gumtree customer email address, 
//send replied mail via mail server provider";
//                MailMessage oMail = new MailMessage("LeiXi2003@yahoo.com.au", "gdutjim@gmail.com",subject,body);
//                System.Net.Mail.SmtpClient oSmtp = new System.Net.Mail.SmtpClient();
//                oSmtp.Host = "smtp.mail.yahoo.com";
//                oSmtp.Credentials = new NetworkCredential("LeiXi2003@yahoo.com.au", "MySixthLove20150501");
//                oSmtp.EnableSsl = true;
//                oSmtp.Port = 587;
//                oSmtp.Send(oMail);
                
            }
            catch (Exception ex)
            {
                Console.Write(ex.Message);
            }
        }

    }
}
