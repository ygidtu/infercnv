Visit project [wiki](https://github.com/broadinstitute/inferCNV/wiki) for InferCNV documentation.

---

# GPU version of inferCNV

#Requirments

尝试过用rpud，但是居然是闭源商业项目，收费太贵了

rpud需要编译protoc (v3.14)

## GPUTools

Download [github](https://github.com/nullsatz/gputools)

Installation `R CMD INSTALL --configure-args="--with-nvcc=/usr/local/cuda-10.0/bin/nvcc --with-r-lib=/usr/local/lib/R/include/ --with-r-include=/usr/local/lib/R/include" gputools_1.1.tar.gz`

**Note**: from the configure, the compile program need the right `R.h` path. just use the `--with-r-include` to specify it.


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