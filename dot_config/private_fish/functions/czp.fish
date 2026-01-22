function czp -d "chezmoi push: cd, add, commit, and push"
    if test (count $argv) -lt 1
        echo "错误: 请提供 commit 信息"
        echo "用法: czp \"你的提交信息\""
        return 1
    end

    # 进入 chezmoi 源目录
    cd (chezmoi source-path)
    # 执行 git 操作
    git add .
    git commit -m "$argv"
    git push
    # 返回之前的目录
    prevd
end
