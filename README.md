Code to run the main analyses from https://www.biorxiv.org/content/10.1101/2021.06.06.447249v1.

Note that here there's only individual preprocessed MEG data for the first two subjects due to space limitations. Data from all subjects can be found at https://www.dropbox.com/sh/c52di7x1tt2k3jp/AABPov3W6-c9dH0TViBECHj7a?dl=0.

Replay results can be reproduced based on summary stats in results file 'Replay_InferenceTime.mat' (or 'Replay_InferenceTime_SepIntervals.mat' to reproduce Supplementary Figure 6) and 'Replay_InferenceLag.mat' or re-run using individual pre-processed data. Either way, start with the 'Replay_InferenceTime.m' (Figures 6 D-F) and 'Replay_InferenceLag.m' (Figure 6C) script.

Use 'ObtaindecodingAcc.m' to obtain decoding accuracy, and 'obtain_ClassifierConfusion.m' to reproduce classifier reproducibility (Figure 6A).

MEG RSA can be reproduced using 'RSA_inference.m' (Figure 5). Summary stats 'RSA_inference.mat' can be found in the link above.

Second level univariate fMRI results can be found in 'fMRI_SummaryStats_Univariate' in the above link. Code used to produce the univariate results (Figure 2, Figure 3C) is in 'Stats_FirstLevel_Suppression.m' in the fMRI_code folder.

Second level multivariate ('silhouette algebra') fMRI results can be found in 'fMRI_SummaryStats_Algebra' in the above link. Code used to produce the silhouette algebra results (Figure 3B) is in 'mk_RSA_STIMS_ALGEBRA_ols_vol.m' in the fMRI_code folder.

## Training data and code (added in this fork)

Behavioural data from the two-day training ("Tetris") sessions, plus the task and analysis code, were recovered from the institute's servers by Philipp Schwartenbeck and shared with Sylvia in 2026.

- `MEG_Behav/Training_MEG/s03–s23/`: training data for each subject (already in the upstream repo). The `Decompose_Tetris_*` files are the relevant ones. `Missing_Data.txt` lists the missing sessions.
- `MEG_Behav/Training_MEG/pilot/`: pilot subjects s2 and s99 (s99 looks like test runs).
- `Training_task/`: the task code (`Task_train_decompose_v2.m`, `Task_train.m` and drawing helpers), the participant instructions, and the 2-day training checklist. `stray_logs/` holds Cogent logs found alongside the task code. Their names collide with the MEG task logs but their contents differ, and it's unclear which sessions they belong to.
- `Training_analysis/`: basic preprocessing and the training-performance plot. Start with `ana_ErrorTrials_train.m`, which sets its own paths relative to the repo. Helper functions that duplicated `MEG_code/` were left out, and the script adds `MEG_code/` to the path instead. `Functions_LEGO/mk_PlotSotErrbar_Group_PS.m` differs from the `MEG_code/` version only in plot styling.

- `MEG_task/`: code for the MEG experiment from the same share. `Task_Lego_MEG.m` is the main silhouette-inference task and `Localiser_Lego_MEG.m` is the localiser. Also here: stimulus generation (`mk_stims*.m`, `basic_3FORMs_*.mat`), the texture and feedback images (`*.bmp`), and the scanning checklist. These are the scanner versions, with real-run settings. `test_versions/` holds a later desktop copy of `Task_Lego_MEG.m` (test mode, `snum = 99`) and a `mk_stims_sparse.m` variant. The scanner version of `mk_stims_sparse.m` loads `basic_3FORMs{2,3,4}_sparse_...` files that weren't in the share. The test version's commented-out lines point to the `sparse{2,3,4}` files included here. All scripts use hard-coded Windows paths that need editing before they'll run.
- The tasks require the Cogent 2000 MATLAB toolbox (Windows only). It was in the share but isn't included here, since it's third-party and mostly Windows binaries.

Note: `Training_task/randsample.m` shadows MATLAB's built-in `randsample` if that folder is on your path.
