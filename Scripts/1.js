/**作者
 * @author YuanKK
 * 插件名
 * @name Koishi rryth
 * 组织名  预留字段，未来发布插件会用到
 * @origin 空中楼阁
 * 版本号
 * @version 1.0
 * 说明
 * @description 将koishi-plugin-rryth移植到无界
 * 触发正则   在bncr 所有的rule都被视为正则
 * @rule ^rr([\s\S]+)$
 * @rule ^([\s\S]+)rr$
 * // 是否管理员才能触发命令
 * @admin false
 * // 是否发布插件，预留字段，可忽略
 * @public false
 * // 插件优先级，越大优先级越高  如果两个插件正则一样，则优先级高的先被匹配
 * @priority 9999
 * // 是否禁用插件
 * @disable false
 * // 是否服务模块，true不会作为插件加载，会在系统启动时执行该插件内容
 * @service false
 */

module.exports = async s => {
    const axios = require('axios');
    axios({
        method: 'post', url: 'http://10.0.0.1:88/ctlogin.cmd', headers: {
            'User-Agent': 'Apifox/1.0.0 (https://apifox.com)', 'Content-Type': 'application/x-www-form-urlencoded'
        }, data: {
            'username': 'useradmin', 'password': 'yOjPD'
        }
    }).then(function (response) {
        let loginCk = response['headers'].get('set-cookie')[0];
        console.log('cookie: ' + loginCk);

        axios({
            method: 'get', url: 'http://10.0.0.1:88/resetrouter.html', headers: {
                'Cookie': loginCk, 'User-Agent': 'Apifox/1.0.0 (https://apifox.com)'
            }
        }).then(function (response) {
            let sessionKey = response.data.match(/sessionKey='\d+'/)[0];
            console.log('sessionKey: ' + sessionKey);

            axios({
                method: 'get', url: 'http://10.0.0.1:88/rebootinfo.cgi?' + sessionKey, headers: {
                    'Cookie': loginCk, 'User-Agent': 'Apifox/1.0.0 (https://apifox.com)'
                }
            }).then(function (response) {
                console.log(response)
            })
                .catch(function (error) {
                    console.log(error);
                });
        })
            .catch(function (error) {
                console.log(error);
            });
    })
        .catch(function (error) {
            console.log(error);
        });
}
