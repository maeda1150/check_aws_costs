# Check aws cost

## environment

Mac OS X EL Capitan
ver 10.11.4

### need

| program | version |
|-----|-----|
| ruby | 2.3.1 |

## prepare

### install bundler

```
$ gem install bundler
```

### install gem set into vendor/bundler path

```
$ bundle install --path vendor/bundler
```

### create database

```
$ bundle exec rake db:migrate
```

## set config

```
$ mkdir aws_config
$ cd aws_config
$ touch aws_config.yml
```

write to aws_config.yml
```
-
  profile: name_1
  access_key_id: XXXXXXXXXXXXXXXXXXXX
  secret_access_key: ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
-
  profile: name_2
  access_key_id: XXXXXXXXXXXXXXXXXXX
  secret_access_key: ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
```

```
$ cd aws_config
$ touch slack_config.yml
```

write to slack_config.yml
```
token: xxxx-11111111111-1111111111111111-xxxxxxxxxxxx
```

## execute command

### sync cost to database

```
$ bundle exec ruby sync_cost.rb
```

### post cost to slack

```
$ bundle exec ruby post_cost.rb
```

### display cost to command line

```
$ bundle exec ruby disp_cost.rb
```

### set crontab

```
$ mkdir log
$ bundle exec whenever --update-crontab
```

confirm

```
$ bundle exec whenever
```
