#=== conf ===
result_de = "de.txt"
result_cpm = "cpm.tmm.txt"
result_blast = "blastx_results.txt"
gene_annotation_file = "TAIR10_functional_descriptions_20130831.txt"
#===

## load result_cpm
data_cpm = {}
result_cpm_colnames = nil
File.open(result_cpm).each_with_index do |l, i|
  a = l.chomp.split(/\t/)
  if i == 0
    result_cpm_colnames = a.map{|x| "#{x}_norm_count"}
  else

    id = a[0]
    data_cpm[id] = a
  end
end


## load blast tophit
data_blast = {}
File.open(result_blast).each do |l|
  a = l.chomp.split(/\t/)
  id = a[0]
  data_blast[id] = a[1]
end

## load gene annotation
data_annot = {}
File.open(gene_annotation_file).each_with_index do |l, i|
  next if i == 0
  a = l.chomp.split(/\t/)
  gene = a[0]
  data_annot[gene] = a
end

## merge

File.open(result_de).each_with_index do |l, i|
  out = nil
  a = l.chomp.split(/\t/)
  if i == 0
    out = [a, 
           result_cpm_colnames].flatten
  else


    id = a[0]
    data_cpm[id]
    out = [a, 
           data_cpm[id],
           data_blast[id],
           data_annot[data_blast[id]],
          ].flatten
  end
  puts out.join("\t")
end
