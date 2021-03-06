#!/usr/bin/env zsh
# Set $0 correctly in any context
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# We need zparseopts
zmodload zsh/zutil

fpath+=("${0:h}/functions")
autoload -Uz is-at-least prompt_dir_glob::{build,add_glob,clear_cache,is_dir_gw}

declare -ga prompt_dir_glob__globs
declare -gA prompt_dir_glob__{prefix,suffix,truncate}
declare -gA __prompt_dir_glob__{truncate_,}cache
: ${PROMPT_DIR_GLOB__CACHE_FILE:="${XDG_CACHE_HOME:-$HOME/.cache}/prompt_dir_glob.cache.zsh"}
: ${PROMPT_DIR_GLOB__SEPARATOR:=${POWERLEVEL9K_DIR_SEPARATOR:-'/'}}
: ${PROMPT_DIR_GLOB__TRUNCATE_CONT=$'\u2025'}

[[ -r $PROMPT_DIR_GLOB__CACHE_FILE ]] && . $PROMPT_DIR_GLOB__CACHE_FILE

function prompt_dir_glob::flush_cache() {
	typeset -p __prompt_dir_glob__{truncate_,}cache >| $PROMPT_DIR_GLOB__CACHE_FILE
	zcompile $PROMPT_DIR_GLOB__CACHE_FILE
}
