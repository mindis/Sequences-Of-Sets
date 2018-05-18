# Common utility code

const SetSequences = Vector{Vector{Set{Int32}}}

struct SequenceData
    sequence::Vector{Int32}
    sizes::Vector{Int32}
end

function pack_data(seqs::SetSequences)
    ret = Vector{SequenceData}()
    for seq in seqs
        sequence = Int32[]
        sizes = Int32[]
        for subset in seq
            v = sort(collect(subset))
            append!(sequence, v)
            push!(sizes, length(v))
        end
        push!(ret, SequenceData(sequence, sizes))
    end
    return ret
end

function read_data(dataset::AbstractString)
    set_seqs = Vector{Vector{Set{Int32}}}()
    for line in eachline("data/$dataset-seqs.txt")
        nverts, simps = split(line, ";")
        nverts = [parse(Int32, v) for v in split(nverts, ",")]
        simps  = [parse(Int32, v) for v in split(simps,  ",")]
        user_set_seq = Vector{Set{Int32}}()
        curr_ind = 1
        for nv in nverts
            simp = Set{Int32}(simps[curr_ind:(curr_ind + nv - 1)])
            push!(user_set_seq, simp)
            curr_ind += nv
        end
        push!(set_seqs, user_set_seq)
    end
    return set_seqs
end

read_packed_data(dataset::AbstractString) =
    pack_data(read_data(dataset))
    
function dataset_info()
    return [["tags-mathoverflow",   "o"],
            ["tags-math-sx",        "o"],
            ["email-Enron-core",    "s"],
            ["email-Eu-core",       "s"],
            ["contact-prim-school", "x"],
            ["contact-high-school", "x"],
            ["coauth-Business",     "<"],
            ["coauth-Geology",      "<"]]
end
