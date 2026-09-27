#!/bin/bash
# Перенаправляет PHP mail() в Mailpit, если MAILPIT_ENABLED=1.
# wp_mail() использует PHPMailer и по умолчанию зовёт mail(), поэтому письма
# не уходят наружу, а открываются в веб-интерфейсе Mailpit.

ini=/usr/local/etc/php/conf.d/php.ini

if [[ ${MAILPIT_ENABLED:-0} != 1 ]]; then
  log warning "Mailpit выключен — письма пойдут через системный sendmail"
else
  if grep -q 'mailpit sendmail' "$ini"; then
    log success "Почта PHP уже направлена в Mailpit"
  else
    printf '\n[mail]\nsendmail_path = "/usr/local/bin/mailpit sendmail --smtp-addr %s"\n' "$MAILPIT_HOST" >> "$ini"
    log success "Письма PHP будут попадать в Mailpit ($MAILPIT_HOST)"
  fi
fi
