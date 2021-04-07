select
    t2.nb_mcpj_anal_causa_distorcao as causa_distorcao,
    t3.nb_mcpj_anal_setor_resp as responsavel_tratamento,
    t5.cd_ca_nivel3 as ca_nivel3,
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
where t1.dd_anal_num_analise in (select num_analise from u01406263605.aceitacoes_v2)