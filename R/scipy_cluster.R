

scipy_hclust <- function(data, method="ward", metric="euclidean") {
    scipy <- reticulate::import("scipy")
    Z = scipy$cluster$hierarchy$linkage(scipy$spatial$distance$pdist(data, metric=metric), method='ward', metric=metric)
    return(list(
        "labels"=rownames(data), "order"=scipy$cluster$hierarchy$leaves_list(Z) + 1,
        "height"=round(Z[, 3]), "Z"=Z
    ))
}


scipy_dist <- function(data, metric="euclidean", p=2) {
    scipy <- reticulate::import("scipy")
    return(scipy$spatial$distance$pdist(data, metric=metric, p=p))
}

scipy_cutree <- function(data, h=NULL, k=NULL) {
    scipy <- reticulate::import("scipy")
    tree = scipy$cluster$hierarchy$cut_tree(data$Z, n_clusters=k, height=h)
    return(tree[, 1] + 1)
}