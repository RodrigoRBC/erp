FROM maxive/erp-base
MAINTAINER cleb. clebaresu@gmail.com

ENV REFRESHED_AT 2014-10-02
## TODO: change this date when you want to make a new build

# Update odoo server
WORKDIR /opt/odoo/server/
RUN git pull
RUN git checkout 8.0
RUN python setup.py install

RUN mkdir -p /opt/odoo/sources
WORKDIR /opt/odoo/sources

## Git repositories and python dependencies
## TODO:remove the ones you are not going to use

# Usual adhoc generic addons
RUN git clone https://github.com/ingadhoc/odoo-addons.git
RUN git clone https://github.com/ingadhoc/odoo-argentina.git
RUN pip install geopy==0.95.1 BeautifulSoup
RUN git clone https://github.com/ingadhoc/odoo-web.git

# Non-Usual adhoc generic addons

# Adhoc specific projects
RUN git clone https://github.com/ingadhoc/odoo-kinesis-athletics
RUN pip install xlrd

# Usual OCA addons
RUN git clone https://github.com/OCA/server-tools
RUN git clone https://github.com/OCA/web

# Non-Usual OCA addons

# Other usual addons

# Other Non-usual addons

## Checkout last for master or specific commit for testing or release
## TODO: remove the ones you are not going to use and add the missing ones

# Usual adhoc generic addons
RUN git --work-tree=/opt/odoo/sources/odoo-addons --git-dir=/opt/odoo/sources/odoo-addons/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-argentina --git-dir=/opt/odoo/sources/odoo-argentina/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-web --git-dir=/opt/odoo/sources/odoo-web/.git checkout master
RUN git --work-tree=/opt/odoo/sources/odoo-kinesis-athletics --git-dir=/opt/odoo/sources/odoo-kinesis-athletics/.git checkout master

# Non-Usual adhoc generic addons

# Adhoc specific projects

# Usual OCA addons
RUN git --work-tree=/opt/odoo/sources/server-tools --git-dir=/opt/odoo/sources/server-tools/.git checkout 8.0
RUN git --work-tree=/opt/odoo/sources/web --git-dir=/opt/odoo/sources/web/.git checkout 8.0

# Non-Usual OCA addons

# Other usual addons

# Other Non-usual addons

## TODO: change the path according the choosen addons. Set the correct database user in the form
## odoo-{project name}-{version}
RUN sudo -H -u odoo /opt/odoo/server/odoo.py --stop-after-init -s -c /opt/odoo/odoo.conf \
    --db_host=odoo-db --db_user=odoo --db_password=odoo \
    --addons-path=/opt/odoo/server/openerp/addons,/opt/odoo/server/addons,/opt/odoo/sources/odoo-addons,/opt/odoo/sources/odoo-argentina,/opt/odoo/sources/odoo-web,/opt/odoo/sources/odoo-kinesis-athletics/addons,/opt/odoo/sources/server-tools,/opt/odoo/sources/web

CMD ["sudo", "-H", "-u", "odoo", "/opt/odoo/server/odoo.py", "-c", "/opt/odoo/odoo.conf"]
