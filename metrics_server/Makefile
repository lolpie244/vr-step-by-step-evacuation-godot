IGNORE_OUTPUT := &> /dev/null


.PHONY: --docker
--docker:
	@docker compose up

.PHONY: --ngrok
--ngrok:
	@ngrok http 8000 --log=stdout > ngrok.log


.PHONY: --log-url
--log-url:
	@sleep 1
	@echo "Server url: `grep "started tunnel" ngrok.log | sed -n 's/.*url=\([^ ]*\).*/\1/p'`"
	@echo "Metabase url: http://127.0.0.1:3000"

.PHONY: --up
--up: --docker --ngrok --log-url

.PHONY: up
up:
	@$(MAKE) -j3 -- --up
