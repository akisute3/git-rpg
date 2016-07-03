# coding: utf-8

# 設定ファイル読み込み
APP_CONFIG = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/settings.yml"))
