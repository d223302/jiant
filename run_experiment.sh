#!/usr/bin/env bash
source activate sp-env
pushd /home/dcml0714/jiant
source /home/dcml0714/jiant/user_config_template.sh
source /home/dcml0714/jiant/scripts/edgeprobing/exp_fns.sh 
bert_root=/work/dcml0714/bert_en/pytorch_model/
output_file=$1
start_step=$2
end_step=$3
random_num=$4
for (( step=$start_step; step<=$end_step; step+=1000 )); do
  for layer in {8..11}; do
    # SRL part	  
    bert_at_k_exp edges-srl-ontonotes bert-base-cased $layer $bert_root/pytorch_model-$step.bin 2 $random_num # 8000 steps /epoch
    srl_output_dir=/work/dcml0714/jiant-result/bert-base-cased-at_$layer-edges-srl-ontonotes-$random_num/
    micro_avg=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $2}' | awk -F ',' '{print $1}')
    macro_avg=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $3}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_mcc=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $4}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_acc=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $5}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_precision=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $6}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_recall=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $7}' | awk -F ',' '{print $1}')
    edges_srl_ontonotes_f1=$(cat $srl_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $8}' | awk -F ',' '{print $1}')
    echo $step,$layer,$micro_avg,$macro_avg,$edges_srl_ontonotes_mcc,$edges_srl_ontonotes_acc,\
         $edges_srl_ontonotes_precision,$edges_srl_ontonotes_recall,$edges_srl_ontonotes_f1 | \
         tee -a /home/dcml0714/jiant/exp_out/srl/$output_file > /dev/null     
    rm -rf $srl_output_dir

    # POS part
   bert_at_k_exp edges-pos-ontonotes bert-base-cased $layer $bert_root/pytorch_model-$step.bin  1 $random_num 
    pos_output_dir=/work/dcml0714/jiant-result/bert-base-cased-at_$layer-edges-pos-ontonotes-$random_num/
    micro_avg=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $2}' | awk -F ',' '{print $1}')
    macro_avg=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $3}' | awk -F ',' '{print $1}') 
    edges_pos_ontonotes_mcc=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $4}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_acc=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $5}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_precision=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $6}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_recall=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $7}' | awk -F ',' '{print $1}')
    edges_pos_ontonotes_f1=$(cat $pos_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $8}' | awk -F ',' '{print $1}')
    echo $step,$layer,$micro_avg,$macro_avg,$edges_pos_ontonotes_mcc,$edges_pos_ontonotes_acc,\
	 $edges_pos_ontonotes_precision,$edges_pos_ontonotes_recall,$edges_pos_ontonotes_f1 | \
         tee -a /home/dcml0714/jiant/exp_out/pos/$output_file > /dev/null
    rm -rf $pos_output_dir

    # Coref Part
#    bert_at_k_exp edges-coref-ontonotes bert-base-cased $layer $bert_root/pytorch_model-$step.bin 1 $random_num
#    coref_output_dir=/work/dcml0714/jiant-result/bert-base-cased-at_$layer-edges-coref-ontonotes-$random_num/ 
#    micro_avg=$(cat $coref_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $2}' | awk -F ',' '{print $1}')
#    macro_avg=$(cat $coref_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $3}' | awk -F ',' '{print $1}')
#    edges_coref_ontonotes_mcc=$(cat $coref_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $4}' | awk -F ',' '{print $1}')
#    edges_coref_ontonotes_acc=$(cat $coref_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $5}' | awk -F ',' '{print $1}')
#    edges_coref_ontonotes_precision=$(cat $coref_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $6}' | awk -F ',' '{print $1}')
#    edges_coref_ontonotes_recall=$(cat $coref_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $7}' | awk -F ',' '{print $1}')
#    edges_coref_ontonotes_f1=$(cat $coref_output_dir/results.tsv | head -n 1 | awk -F ':' '{print $8}' | awk -F ',' '{print $1}')
#    echo $step,$layer,$micro_avg,$macro_avg,$edges_coref_ontonotes_mcc,$edges_coref_ontonotes_acc,\
#         $edges_coref_ontonotes_precision,$edges_coref_recall,$edges_coref_ontonotes_f1 | \
#         tee -a /home/dcml0714/jiant/exp_out/coref/$output_file > /dev/null
#    rm -rf $coref_output_dir
  done   
done  
