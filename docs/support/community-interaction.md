欢迎加入 New API 开源社区！在这里，你可以与其他开发者交流经验，分享想法。

## 📜 群规则

为了维护良好的社区氛围，请遵守以下规则：

!!! warning "重要提示"
    违反以下规则可能会被移出群聊，请各位成员仔细阅读并遵守。

1. 本群管理和群主没有任何义务为您提供任何技术支持，如有问题请提交 [issue](feedback-issues.md)
2. 群聊禁止发布任何账号出售、求购相关信息，群昵称禁止出现任何购买引导、求购相关信息
3. 本群不出售任何api产品，请勿听信购买任何人的api产品（包括管理员的）
4. New API不存在收费版本
5. 必须在遵循相关法律法规的条件下使用本项目，禁止讨论任何非法话题

!!! tip "温馨提示"
    如果您有任何功能建议或bug反馈，建议直接在GitHub上提交issue，这样可以更好地追踪和解决问题。

## 🤝 加入我们的QQ交流群

!!! info "加入前请完成问卷"
    请认真阅读上述群规则后，完成以下问卷验证。只有全部答对才能显示QQ群信息。

<div id="quizContainer" style="margin: 20px 0;">
    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">1. New API 是什么？</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="a" style="margin-right: 8px;">
            <span>一个商业API销售平台</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="b" style="margin-right: 8px;">
            <span>开源的 AI 接口管理与分发系统</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="c" style="margin-right: 8px;">
            <span>一个付费软件</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="d" style="margin-right: 8px;">
            <span>一个公益API站点</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">2. 群里可以发布账号或API产品求购信息吗？</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q2" value="true" style="margin-right: 8px;">
            <span>可以</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q2" value="false" style="margin-right: 8px;">
            <span>不可以</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">3. New API 是否存在收费版本？</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q3" value="true" style="margin-right: 8px;">
            <span>存在收费版本</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q3" value="false" style="margin-right: 8px;">
            <span>不存在收费版本，完全免费开源</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">4. 群主和管理员是否有义务为我提供技术支持？</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q4" value="true" style="margin-right: 8px;">
            <span>有义务提供技术支持</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q4" value="false" style="margin-right: 8px;">
            <span>没有义务提供技术支持，应提交 issue</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">5. 群内可以购买管理员出售的 API 产品吗？</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q5" value="true" style="margin-right: 8px;">
            <span>可以购买</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q5" value="false" style="margin-right: 8px;">
            <span>不可以，本群不出售任何 API 产品</span>
        </label>
    </div>

    <div id="quizError" style="display: none; padding: 12px; background: #ffebee; color: #c62828; border-radius: 4px; margin-bottom: 15px; border-left: 4px solid #c62828;">
        <strong>⚠️ 回答错误！</strong><br>
        <span id="errorMessage">请认真阅读群规则后重新作答。</span>
    </div>

    <button id="submitQuiz" style="width: 100%; padding: 12px 20px; background: #1976d2; color: white; border: none; border-radius: 4px; font-size: 15px; font-weight: 500; cursor: pointer; transition: background 0.3s;">
        提交答案
    </button>
</div>

<div id="qqGroupInfo" style="display: none; opacity: 0; transition: opacity 0.3s ease-in; margin-top: 20px;">
    <h3>方式一：扫描二维码</h3>
    <p><img src="/assets/qq_3.jpg" alt="QQ群二维码" style="max-width: 300px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);"></p>
    <h3>方式二：点击链接</h3>
    <p><a href="https://qm.qq.com/q/Y79glR8raU" target="_blank" style="display: inline-block; padding: 10px 20px; background: #1976d2; color: white; text-decoration: none; border-radius: 4px; font-weight: 500;">点击这里直接加入QQ群</a></p>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const submitBtn = document.getElementById('submitQuiz');
    const qqGroupInfo = document.getElementById('qqGroupInfo');
    const quizError = document.getElementById('quizError');
    const errorMessage = document.getElementById('errorMessage');
    const quizContainer = document.getElementById('quizContainer');
    
    // 正确答案
    const correctAnswers = {
        q1: 'b',  // New API 是开源的 AI 接口管理与分发系统
        q2: 'false',  // 不可以发布求购信息
        q3: 'false',  // 不存在收费版本
        q4: 'false',  // 没有义务提供技术支持
        q5: 'false'   // 不可以购买 API 产品
    };
    
    // 错误提示信息
    const errorMessages = {
        q1: '请再次阅读项目介绍，New API 是一个开源的 AI 接口管理与分发系统。',
        q2: '根据群规则第2条：群聊禁止发布任何账号或API产品出售、求购相关信息。',
        q3: '根据群规则第4条：New API 不存在收费版本，完全免费开源。',
        q4: '根据群规则第1条：本群管理和群主没有任何义务为您提供任何技术支持，如有问题请提交 issue。',
        q5: '根据群规则第3条：本群不出售任何 API 产品，请勿听信购买任何人的 API 产品（包括管理员的）。'
    };
    
    if (submitBtn) {
        submitBtn.addEventListener('click', function() {
            // 隐藏之前的错误信息
            quizError.style.display = 'none';
            
            // 检查是否所有题目都已作答
            let allAnswered = true;
            let wrongAnswers = [];
            
            for (let question in correctAnswers) {
                const selected = document.querySelector(`input[name="${question}"]:checked`);
                if (!selected) {
                    allAnswered = false;
                    break;
                }
                
                // 检查答案是否正确
                if (selected.value !== correctAnswers[question]) {
                    wrongAnswers.push(question);
                }
            }
            
            if (!allAnswered) {
                errorMessage.innerHTML = '请回答所有问题后再提交。';
                quizError.style.display = 'block';
                quizError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                return;
            }
            
            if (wrongAnswers.length > 0) {
                // 显示第一个错误的详细信息
                errorMessage.innerHTML = errorMessages[wrongAnswers[0]];
                quizError.style.display = 'block';
                quizError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                
                // 将按钮变红并添加摇晃动画
                submitBtn.style.background = '#c62828';
                submitBtn.style.animation = 'shake 0.5s';
                setTimeout(() => {
                    submitBtn.style.background = '#1976d2';
                    submitBtn.style.animation = '';
                }, 1000);
            } else {
                // 全部答对，显示 QQ 群信息
                quizError.style.display = 'none';
                quizContainer.style.display = 'none';
                qqGroupInfo.style.display = 'block';
                setTimeout(() => {
                    qqGroupInfo.style.opacity = '1';
                }, 10);
                
                // 显示成功消息
                const successMsg = document.createElement('div');
                successMsg.style.cssText = 'padding: 15px; background: #e8f5e9; color: #2e7d32; border-radius: 4px; margin-bottom: 20px; border-left: 4px solid #4caf50;';
                successMsg.innerHTML = '<strong>✅ 恭喜通过验证！</strong><br>感谢您认真阅读群规则，欢迎加入我们的社区！';
                qqGroupInfo.parentElement.insertBefore(successMsg, qqGroupInfo);
                
                successMsg.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });
        
        // 按钮悬停效果
        submitBtn.addEventListener('mouseenter', function() {
            if (this.style.background !== 'rgb(198, 40, 40)') {
                this.style.background = '#1565c0';
            }
        });
        
        submitBtn.addEventListener('mouseleave', function() {
            if (this.style.background !== 'rgb(198, 40, 40)') {
                this.style.background = '#1976d2';
            }
        });
    }
});
</script>

<style>
@keyframes shake {
    0%, 100% { transform: translateX(0); }
    10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
    20%, 40%, 60%, 80% { transform: translateX(5px); }
}
</style>
