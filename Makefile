link: .clerk/clerk/clerk.toml .clerk/clerk/litestream.yaml
	scripts/link.sh

dirs:
	mkdir -p .shadowenv.d
	mkdir -p .clerk/data
	mkdir -p .clerk/clerk

.clerk/clerk/transform.keto: dirs .shadowenv.d/.01-upstream.lisp
	cp templates/transform.keto .clerk/clerk/transform.keto

.clerk/clerk/clerk.toml: dirs .shadowenv.d/.01-upstream.lisp
	tera --env-only --template templates/clerk.toml.j2 > .clerk/clerk/clerk.toml

.clerk/clerk/litestream.yaml: dirs .shadowenv.d/.01-upstream.lisp
	tera --env-only --template templates/litestream.yaml.j2 > .clerk/clerk/litestream.yaml

.shadowenv.d/.01-upstream.lisp: dirs
	tera --env-only --template templates/01-upstream.lisp.j2 > .shadowenv.d/.01-upstream.lisp
	shadowenv trust

clean:
	rm -rf .clerk
