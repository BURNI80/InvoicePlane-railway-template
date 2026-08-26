FROM funktionslust/invoiceplane:1.6.5

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["apache2-foreground"]
