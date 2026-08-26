FROM funktionslust/invoiceplane:1.6.5

RUN a2dismod mpm_event mpm_worker 2>/dev/null; \
    a2enmod mpm_prefork 2>/dev/null; \
    true
