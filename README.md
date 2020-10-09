# Post-QC variant counts: A chip-specific hierarhical model

A simple hierarchical model of post-QC SNP counts across genotyping chips. The goal was to develop a set of models for common QC metrics for incoming genotyping collections. The first metric we looked at: how many variants are left after an initial round of QC?

Because the number of variants depends on the genotyping chip, and we had few studies with observed post-QC variant counts, I decided to try out a hierarchical model.

This works, but is vastly more complicated than it needs to be. We did end up using the the posterior distribution to set thresholds for per-platform, post-QC variant counts. Those are in the latest version of the Ricopili QC report.

![SNP Count PPV](/reports//snp_count_ppv.png)
