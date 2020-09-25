Visit project [wiki](https://github.com/broadinstitute/inferCNV/wiki) for InferCNV documentation.

---

# CHANGELOG

- **2020.09.25**: 
  1. using `scipy.cluster.hierarchy` to replace the R  default `hclust` and `gpuHclust`. `scipy` is way much faster and way much eaiser to deploy than gputools
  2. disable multiple plots, due to scipy dengraom not working like R, and this may a little bit more faster


# inferCNV

[github](https://github.com/broadinstitute/infercnv)

inferCNV just too slow when deal with huge mount of cells

I noticed step 5, 11, 13 and the plotting is the main steps slow it down.

So the changes in this version are listed:
    - step5: add `multiporocessing` using `doMC`
    - step6: caused by `dist` and `hclust`, replaced with `gpuDist` and `gpuHclust`
    - step13: nothing changed
    - plotting: same with step6


### inferCNV_ops.R

原本`.subtract_expr`有下方第一种形式改为第二种，以增加多进程支持。亲测可显著提升速度

```R
subtr_data <- do.call(rbind, lapply(seq_len(nrow(expr_matrix)), subtract_normal_expr_fun))

subtr_data <- foreach(i = seq_len(nrow(expr_matrix)), .combine="rbind") %dopar% {
  subtract_normal_expr_fun(i)
}
```



同时在原本语句下方注册`doMC`的threads

```R
infercnv.env$GLOBAL_NUM_THREADS <- num_threads
registerDoMC(num_threads)
```



其余将全局范围内的`dist`以及`hclust`改为`gpuDist`以及`gpuHclust`。



此外，默认的`hclust_method`也需更改为对应的`ward.D`



### NAMESPACE

添加`import(gputools)`和`import(doMC)`



### 安装

`devtools::install_local('path/to/infercnv', force = T)`
