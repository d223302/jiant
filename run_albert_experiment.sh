#!/usr/bin/env bash
# Usage: ./run_albert_experiment start_step end_step stride random_int
source activate sp-env
pushd /home/dcml0714/jiant
source /home/dcml0714/jiant/user_config_template.sh
source /home/dcml0714/jiant/scripts/edgeprobing/exp_fns.sh 
bert_root=/work/dcml0714/albert/pytorch_model/
#start_step=$1
#end_step=$2
#stride=$3
#random_num=$4
#for (( step=$start_step; step<=$end_step; step+=$stride )); do
step=$1
random_num=$step
  for layer in 7; do
    # SRL part	  
    albert_at_k_exp edges-srl-ontonotes albert $layer $bert_root/pytorch_model_$step.bin 5 $random_num # 8000 steps /epoch
    #albert_at_k_exp edges-srl-ontonotes albert $layer albert-base-v1 2 $random_num
    srl_output_dir=/work/dcml0714/jiant-result/albert-at_$layer-edges-srl-ontonotes-$random_num/
    micro_avg=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $2}' | awk -F ',' '{print $1}')
    macro_avg=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $3}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_mcc=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $4}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_acc=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $5}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_precision=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $6}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_recall=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $7}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_f1=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $8}' | awk -F ',' '{print $1}')
    echo $step,$layer,$micro_avg,$macro_avg,$edges_srl_ontonotes_mcc,$edges_srl_ontonotes_acc,\
         $edges_srl_ontonotes_precision,$edges_srl_ontonotes_recall,$edges_srl_ontonotes_f1 | \
         tee -a /home/dcml0714/albert_embryo/exp_result/probe/srl.txt > /dev/null     
    rm -rf $srl_output_dir

    # POS part
    albert_at_k_exp edges-pos-ontonotes albert $layer $bert_root/pytorch_model_$step.bin 3 $random_num 
    #albert_at_k_exp edges-pos-ontonotes albert $layer albert-base-v1  1
    pos_output_dir=/work/dcml0714/jiant-result/albert-at_$layer-edges-pos-ontonotes-$random_num/
    micro_avg=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $2}' | awk -F ',' '{print $1}')
    macro_avg=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $3}' | awk -F ',' '{print $1}') 
    edges_pos_ontonotes_mcc=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $4}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_acc=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $5}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_precision=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $6}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_recall=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $7}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_f1=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $8}' | awk -F ',' '{print $1}')
    echo $step,$layer,$micro_avg,$macro_avg,$edges_pos_ontonotes_mcc,$edges_pos_ontonotes_acc,\
	 $edges_pos_ontonotes_precision,$edges_pos_ontonotes_recall,$edges_pos_ontonotes_f1 | \
         tee -a /home/dcml0714/albert_embryo/exp_result/probe/pos.txt > /dev/null
    rm -rf $pos_output_dir
  done   
#done  
