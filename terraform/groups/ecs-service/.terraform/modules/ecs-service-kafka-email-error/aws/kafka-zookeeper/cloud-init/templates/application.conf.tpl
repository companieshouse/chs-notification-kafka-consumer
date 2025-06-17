write_files:
  - path: ${cmak_home}/conf/application.conf
    owner: ${service_user}:${service_group}
    permissions: 0644
    content: |
      akka {
        loggers = ["akka.event.slf4j.Slf4jLogger"]
        loglevel = "INFO"
      }

      akka.logger-startup-timeout = 60s

      application.features=[${feature_list}]

      basicAuthentication.enabled=${basic_authentication != null}%{ if basic_authentication != null }
      basicAuthentication.username="${basic_authentication.username}"
      basicAuthentication.password="${basic_authentication.password}"
      basicAuthentication.realm="Kafka-Manager"
      basicAuthentication.excluded=["/api/health"] # ping the health of your instance without authentification%{ endif }

      cmak.zkhosts="${zookeeper_connect_string}"

      pinned-dispatcher.executor="thread-pool-executor"
      pinned-dispatcher.type="PinnedDispatcher"

      play.application.loader=loader.KafkaManagerLoader
      play.crypto.secret="^<csmm5Fx4d=r2HEX8pelM3iBkFVv?k[mc;IZE<_Qoq8EkX_/7@Zt6dP05Pzea3U"
      play.http.context = "/"
      play.http.requestHandler = "play.http.DefaultHttpRequestHandler"
      play.http.session.maxAge="1h"
      play.i18n.langs=["en"]
