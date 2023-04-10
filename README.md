# discourse-searchable-user-custom-fields

### Disclaimer

- This plugin was made in 2020 originally a little bit before [Discourse released the searchable profile fields](https://github.com/discourse/discourse/commit/e29605b79f25afac2d506c6371e1b528f120b670). So it may still need some tidying up to get in line with the latest major releases. Sharing in case anyone wants to help make improvements.
- The variable/settings names can be found under `chord` as that's what I originally called the project before migrating it here.
- This was originally forked from the old mingle plugin

## Quick Start in 3 Steps

This quick start shows you how to install this plugin and use it.  Recommended if you have:

* A live discourse forum
* You have deployed your live forum using Docker.  If you're using Digital Ocean, it's likely that your forum is deployed on Docker.

For non-docker or local development installation (those with programming experience), see **Other Installation**.


### Step 1 - Install the Official Discourse Advertising Plugin


As seen in a [how-to on meta.discourse.org](https://meta.discourse.org/t/install-plugins-in-discourse/19157), simply **add the plugin's repository url to your container's app.yml file**:

```yml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - mkdir -p plugins
          - git clone https://github.com/surf-search/discourse-searchable-user-custom-fields.git
```
Rebuild the container

```
cd /var/discourse
git pull
./launcher rebuild app
```

### Step 2 - Configure Your Settings

There are only a few options in configuring your Discourse settings to enable your user custom fields to be searchable:

- Make sure to enable the the plugin
- Set an interval for re-indexing
- Let the plugin know which fields you want to expose for search, separated by the `|` character



------
For testing. throw this project in the discourse/plugins directory

From discourse directory:

`rm -rf tmp; bundle exec rails s`

For the interactive console:

`rails c`

For in line debugging:

`binding.pry`

For starting mailcatcher:

move into the /discourse directory

`mailcatcher`

