<#-- templates/mail/email-confirmation.ftlh -->
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Подтверждение почты</title>
</head>

<body style="margin:0; padding:0; background:#f6f7f9; color:#09090b; font-family:Arial, Helvetica, sans-serif;">
<div style="display:none; max-height:0; overflow:hidden; opacity:0; color:transparent;">
    Подтвердите почту, чтобы завершить регистрацию в ${appName}.
</div>

<table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%"
       style="width:100%; margin:0; padding:42px 16px; background:#f6f7f9;">
    <tr>
        <td align="center">

            <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="720"
                   style="width:100%; max-width:720px; background:#ffffff; border:1px solid #dcdfe4; border-radius:18px; overflow:hidden; box-shadow:0 18px 48px rgba(15,23,42,0.06);">

                <tr>
                    <td align="center"
                        style="padding:34px 40px; border-bottom:1px solid #edf0f3; background:#ffffff;">
                        <table role="presentation" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width:42px; height:42px; border-radius:10px; background:#09090b; color:#ffffff; text-align:center; vertical-align:middle; font-size:18px; font-weight:700; line-height:42px;">
                                    &lt;/&gt;
                                </td>
                                <td style="padding-left:16px; color:#09090b; font-size:28px; font-weight:800; line-height:1;">
                                    ${appName}
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td align="center" style="padding:64px 56px 34px; background:#ffffff;">
                        <p style="margin:0 0 26px; color:#667085; font-size:20px; line-height:1.4;">
                            Здравствуйте, <span style="color:#09090b;">${username}</span>!
                        </p>

                        <h1 style="margin:0; color:#09090b; font-size:44px; line-height:1.08; font-weight:800; letter-spacing:-0.02em;">
                            Подтвердите почту
                        </h1>

                        <p style="max-width:520px; margin:24px auto 0; color:#667085; font-size:20px; line-height:1.5;">
                            Чтобы завершить регистрацию и активировать аккаунт, подтвердите адрес электронной почты.
                        </p>

                        <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="100%"
                               style="margin-top:42px;">
                            <tr>
                                <td align="center">
                                    <a href="${confirmationLink}"
                                       style="display:block; width:100%; max-width:440px; padding:20px 24px; background:#09090b; border-radius:10px; color:#ffffff; text-decoration:none; font-size:21px; font-weight:700; line-height:1.2; box-shadow:0 18px 36px rgba(15,23,42,0.16);">
                                        Подтвердить почту
                                    </a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td style="padding:18px 56px 0; background:#ffffff;">
                        <div style="height:1px; background:#edf0f3; line-height:1px; font-size:1px;">&nbsp;</div>
                    </td>
                </tr>

                <tr>
                    <td style="padding:34px 56px 0; background:#ffffff;">
                        <p style="margin:0 0 12px; color:#667085; font-size:17px; line-height:1.45;">
                            Или перейдите по ссылке:
                        </p>

                        <div style="padding:14px 16px; background:#ffffff; border:1px solid #dcdfe4; border-radius:9px; color:#09090b; font-size:15px; line-height:1.45; word-break:break-all; font-family:Consolas, Monaco, monospace;">
                            <a href="${confirmationLink}"
                               style="color:#09090b; text-decoration:none;">
                                ${confirmationLink}
                            </a>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td style="padding:28px 56px 0; background:#ffffff;">
                        <p style="margin:0; color:#667085; font-size:17px; line-height:1.45;">
                            Ссылка действует до:
                            <span style="color:#09090b; font-weight:700;">${expiresAt}</span>
                        </p>
                    </td>
                </tr>

                <tr>
                    <td style="padding:34px 56px 0; background:#ffffff;">
                        <div style="height:1px; background:#edf0f3; line-height:1px; font-size:1px;">&nbsp;</div>
                    </td>
                </tr>

                <tr>
                    <td style="padding:34px 56px 58px; background:#ffffff;">
                        <p style="margin:0; color:#667085; font-size:17px; line-height:1.5;">
                            Если кнопка не работает, скопируйте ссылку выше и откройте её в браузере.
                        </p>

                        <p style="margin:12px 0 0; color:#98a2b3; font-size:14px; line-height:1.5;">
                            Если вы не создавали аккаунт, просто проигнорируйте это письмо.
                        </p>
                    </td>
                </tr>

            </table>

            <table role="presentation" cellpadding="0" cellspacing="0" border="0" width="720"
                   style="width:100%; max-width:720px;">
                <tr>
                    <td align="center" style="padding:28px 20px 0;">
                        <p style="margin:0; color:#667085; font-size:14px; line-height:1.6;">
                            © 2025 ${appName}. Все права защищены.
                        </p>
                        <p style="margin:8px 0 0; color:#98a2b3; font-size:14px; line-height:1.6;">
                            Это письмо отправлено автоматически, пожалуйста, не отвечайте на него.
                        </p>
                    </td>
                </tr>
            </table>

        </td>
    </tr>
</table>
</body>
</html>