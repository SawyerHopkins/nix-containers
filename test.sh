MY_ARR=('a = 1' 'b')
MY_STR=$(printf '%s\n' "${MY_ARR[@]}")
echo "${MY_STR}"