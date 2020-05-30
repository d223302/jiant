#!/usr/bin/env bash
# Usage: ./run_albert_experiment start_step end_step stride random_int
source activate sp-env
pushd /home/dcml0714/jiant
source /home/dcml0714/jiant/user_config_template.sh
source /home/dcml0714/jiant/scripts/edgeprobing/exp_fns.sh 
bert_root=/work/dcml0714/albert/pytorch_model/
start_step=$1
end_step=$2
stride=$3
#random_num=$4
for (( step=$start_step; step<=$end_step; step+=$stride )); do
#step=$1
random_num=$step
  for layer in 7; do
    # const part
    albert_at_k_exp edges-nonterminal-ontonotes albert $layer $bert_root/pytorch_model_$step.bin 3 $random_num
    const_output_dir=/work/dcml0714/jiant-result/albert-at_$layer-edges-nonterminal-ontonotes-$random_num/
    micro_avg=$(cat $const_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $2}' | awk -F ',' '{print $1}')
    macro_avg=$(cat $const_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $3}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_mcc=$(cat $const_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $4}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_acc=$(cat $const_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $5}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_precision=$(cat $const_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $6}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_recall=$(cat $const_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $7}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_f1=$(cat $const_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $8}' | awk -F ',' '{print $1}')
    echo $step,$layer,$micro_avg,$macro_avg,$edges_pos_ontonotes_mcc,$edges_pos_ontonotes_acc,\
         $edges_pos_ontonotes_precision,$edges_pos_ontonotes_recall,$edges_pos_ontonotes_f1 | \
         tee -a /home/dcml0714/albert_embryo/exp_result/probe/const.txt > /dev/null
    rm -rf $const_output_dir
  done   
done  
