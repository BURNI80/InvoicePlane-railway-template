FROM funktionslust/invoiceplane:1.6.5

RUN a2dismod mpm_event mpm_worker && a2enmod mpm_prefork
