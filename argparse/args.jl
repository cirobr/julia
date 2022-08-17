using ArgParse

s = ArgParseSettings()
@add_arg_table! s begin
    "arg1"
        help     = "Batch size (SGD=1, BGD > 1)"
        default  = 1   # SGD
        required = false

    "arg2"
        help     = "Parallel processing for batch loading"
        default  = false
        required = false

    "arg3"
        help     = "Number of epochs"
        default  = 5
        required = false

    "arg4"
        help     = "Learning rate"
        default  = 0.01
        required = false
end

parsed = parse_args(s)
batchSize          = parsed["arg1"]
parallelProcessing = parsed["arg2"]
epochs             = parsed["arg3"]
η                  = parsed["arg4"]   # learning rate (\eta<tab>)