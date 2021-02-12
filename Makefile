all:
	docker-compose up --build --force-recreate --remove-orphans

run:
	./bin/dotfiles.sh

clean:
	docker-compose stop
	docker-compose down -v
