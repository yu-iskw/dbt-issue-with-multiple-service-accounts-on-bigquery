setup:
	pip install -r requirements.txt

run-terraform: check-project-id check-your-gcp-account
	cd terraform \
		&& terraform init \
		&& terraform apply -auto-approve -var "project_id=$(PROJECT_ID)" "your_gcp_account=$(YOUR_GCP_ACCOUNT)"

run-dbt:
	export PROJECT_ID=$(PROJECT_ID)
	rm -fr logs/* targets/*
	dbt compile --profiles-dir profiles --target dataset1 > resources/run-dbt.log || :
	dbt run --profiles-dir profiles --target dataset1 >> resources/run-dbt.log || :

reproduce-issue: check-project-id
	export PROJECT_ID=$(PROJECT_ID)
	rm -fr logs/* targets/*
	dbt compile --profiles-dir profiles --target dataset1 --select "tag:test_dataset1" > resources/dbt.log || :
	dbt run --profiles-dir profiles --target dataset1 --select "tag:test_dataset1" >> resources/dbt.log || :

clean: clean-terraform

clean-terraform: check-project-id
	cd terraform \
		&& terraform destroy -auto-approve -v "project_id=$(PROJECT_ID)"

check-project-id:
ifndef PROJECT_ID
	$(error PROJECT_ID is undefined)
endif

check-your-gcp-account:
ifndef YOUR_GCP_ACCOUNT
	$(error YOUR_GCP_ACCOUNT is undefined)
endif
