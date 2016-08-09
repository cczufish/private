<?php
//注意，请不要在这里配置SAE的数据库，配置你本地的数据库就可以了。
return array(
        //'配置项'=>'配置值'
        'SHOW_PAGE_TRACE'=>false,
        'URL_HTML_SUFFIX'=>'.html',
        'URL_MODEL'=>2,//rewrite模式，去掉index.php
        // 添加数据库配置信息
        'DB_TYPE'   => 'mysql', // 数据库类型
        'DB_HOST'   => 'localhost', // 服务器地址
        'DB_NAME'   => 'wifikey', // 数据库名
        'DB_USER'   => 'root', // 用户名
        'DB_PWD'    => 'YLYP1JvT9KqL', // 密码
        'DB_PORT'   => 3306, // 端口
        'DB_PREFIX' => '', // 数据库表前缀
        //日志
        'LOG_RECORD' => true, // 开启日志记录
        'LOG_LEVEL'  =>'EMERG,ALERT,CRIT,ERR,INFO,DEBUG', // 只记录EMERG ALERT CRIT ERR 错误
        );
?>
