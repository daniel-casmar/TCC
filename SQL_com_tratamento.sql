with base as
(select
    t2.nb_mcpj_anal_causa_distorcao as causa_distorcao,
    t3.nb_mcpj_anal_setor_resp as responsavel_tratamento,
    case 
	when (t5.cd_ca_nivel3 != "NI" and t5.cd_ca_nivel3 != "650") then t5.cd_ca_nivel3
    when (t7.nm_anal_obs_diagnostico ilike "%IRPJ%" or t7.nm_anal_obs_diagnostico ilike "%ECF%" or t7.nm_anal_obs_diagnostico ilike "%Lucro real%" or t7.nm_anal_obs_diagnostico ilike "%Lalur%" or t7.nm_anal_obs_diagnostico ilike "%IRRF%" or t7.nm_anal_obs_diagnostico ilike "%DIPJ%" or t7.nm_anal_obs_diagnostico ilike "%perdas não técnicas%" or t7.nm_anal_obs_diagnostico ilike "%perdas não-técnicas%" or t2.nb_mcpj_anal_causa_distorcao ilike "%IRPJ%" or t2.nb_mcpj_anal_causa_distorcao ilike "%balancete%" or t2.nb_mcpj_anal_causa_distorcao ilike "%lucro%") then "140"
	when (t7.nm_anal_obs_diagnostico ilike "%previd%" or t7.nm_anal_obs_diagnostico ilike "%GFIP%" or t7.nm_anal_obs_diagnostico ilike "%GPS%"  or t7.nm_anal_obs_diagnostico ilike "%CPRB%" or t7.nm_anal_obs_diagnostico ilike "%Dacon%" or t2.nb_mcpj_anal_causa_distorcao ilike "%GPS%") then "622"
	when (t7.nm_anal_obs_diagnostico ilike "%Cofins%" or t7.nm_anal_obs_diagnostico ilike "%EFD%" or t7.nm_anal_obs_diagnostico ilike "%Sped Contribuições%" or t7.nm_anal_obs_diagnostico ilike "2172" or t2.nb_mcpj_anal_causa_distorcao ilike "%Cofins%") then "500"
	when t7.nm_anal_obs_diagnostico ilike "%Pagamento Unificado%" then "644"
	when t7.nm_anal_obs_diagnostico ilike "%CSLL%" then "580"
	when (t7.nm_anal_obs_diagnostico ilike "%Pis%" or t7.nm_anal_obs_diagnostico ilike "%Pasep%" or t7.nm_anal_obs_diagnostico ilike "%8109%") then "540"
    when (t7.nm_anal_obs_diagnostico ilike "%IPI%"  or t2.nb_mcpj_anal_causa_distorcao ilike "%IPI%") then "060"
    when t7.nm_anal_obs_diagnostico ilike "%IOF%" then "360"
	when t7.nm_anal_obs_diagnostico ilike "%CIDE%" then "612"
    when t7.nm_anal_obs_diagnostico ilike "%Fundaf%" then  "620"
    when (t7.nm_anal_obs_diagnostico = "Não informado" or  t5.cd_ca_nivel3 = "NI") then "Não informado"
    else "Outros" end as ca_nivel3,
	t6.aceitacao as aceitacao
from mcpj.wf_mcpj_anals as t1
    join mcpj.wd_mcpj_anal_causa_distorcaos as t2
      on t1.nr_mcpj_anal_causa_distorcao = t2.nr_mcpj_anal_causa_distorcao
    join mcpj.wd_mcpj_anal_setor_resps as t3
      on t1.nr_mcpj_anal_setor_resp = t3.nr_mcpj_anal_setor_resp
    join dime.wd_rc_ca_nivel6 as t4
      on t1.nr_mcpj_csel_ca_n6_h_crit_sel = t4.nr_ca_nivel6
    join dime.wd_rc_ca_nivel3 as t5
      on t4.nr_ca_nivel3 = t5.nr_ca_nivel3
    join u01406263605.aceitacoes_v2 as t6
      on t1.dd_anal_num_analise = t6.num_analise
    join mcpj.wd_mcpj_anals as t7
      on (t1.dd_anal_num_analise = t7.dd_anal_num_analise and t1.nr_mcpj_anal = t7.nr_mcpj_anal)
where t1.dd_anal_num_analise in (select num_analise from u01406263605.aceitacoes_v2) )

select
causa_distorcao,
responsavel_tratamento,
ca_nivel3,
aceitacao
from base
where causa_distorcao not in ("XX - Causa não identificada", "XX - Outras (descrever em observação)")
and responsavel_tratamento not in ("Não informado")
and ca_nivel3 not in ("Não informado", "Outros")