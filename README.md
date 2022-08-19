Prerequisite: - 

```
Perl,
RabbitMq
MongoDb,
ubuntu linux,
ELK stack
cpan 
Moose
Net::RabbitFoot
    
NET::AMQ
XML::LibXML
```
`mongo db and rabbitmq conf ip 0.0.0.0`

```
sudo apt install x86_64-linux-gnu-gcc
sudo apt install libxml2-dev icu-devtools libicu-dev libstdc++-5-dev libxml2-dev
xml2
libxml2
sudo apt install mtools    
```
`rabbitmq-plugins enable rabbitmq_management`


* logger

`PERL_DL_NONLAZY=1 "/usr/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t`


```
cpan shell
reload
upgrade

Add a new/fresh user, say user ‘test’ and password ‘test’

rabbitmqctl add_user test test
Give administrative access to the new access

rabbitmqctl set_user_tags test administrator
Set permission to newly created user

rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
```

```
Client ID (Consumer Key) FROM RMQ
XXXXXXXXXX--
Client Secret (Consumer Secret)
YYYYYYYYYYYYYYY
```


* Add these config to Conf.pm modify and start
* pull data using Perl script
