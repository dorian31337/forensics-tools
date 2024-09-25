.PHONY: build clean

rules := $(wildcard *.yara)

repo1 = https://github.com/h3x2b/yara-rules.git
repo2 = https://github.com/Neo23x0/signature-base.git
repo3 = https://github.com/InQuest/yara-rules.git
repo4 = https://github.com/reversinglabs/reversinglabs-yara-rules.git

repos := repo1 repo2 repo3 repo4

repos-dir := ./_repos

define nl


endef


clean:
	rm -rf 00_all.yara 00_all.yc $(repos-dir)


clone:
	@$(foreach repo, $(repos), \
		@echo "Cloning $($(repo))... " $(nl) \
		git clone --depth 1 $($(repo)) $(repos-dir)/$(repo) $(nl) \
	)

00_all.yc: clone $(rules)
	find ./ \( -name '*.yara' -o -name '*.yar' -o -name '*.rule' \) -exec echo "include \"{}\"" ";" | sort | egrep -v '00_all.yara|Hunting_Rule_ShikataGaNai.rule|gen_mal_3cx_compromise_mar23.yar|GlowSpark_Downloader.rule|gen_vcruntime140_dll_sideloading.yar|expl_connectwise_screenconnect_vuln_feb24.yar|generic_anomalies.yar|general_cloaking.yar|gen_webshells_ext_vars.yar|thor_inverse_matches.yar|yara_mixed_ext_vars.yar|configured_vulns_ext_vars.yar|gen_fake_amsi_dll.yar|expl_citrix_netscaler_adc_exploitation_cve_2023_3519.yar|rules_vuln_drivers_strict_renamed.yar|miscellaneous.rule|math.yara|inquest.*hunter.*rule' > 00_all.yara
	yarac 00_all.yara 00_all.yc

build: clean 00_all.yc

