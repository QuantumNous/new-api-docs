Welcome to the New API open-source community! Here, you can exchange experiences and share ideas with other developers.

## 📜 Group Rules

To maintain a positive community atmosphere, please adhere to the following rules:

!!! warning "Important Notice"
    Violation of the following rules may result in removal from the chat group. Please read carefully and comply.

1. Group administrators and the group owner are under no obligation to provide you with any technical support. If you have questions, please submit an [issue](feedback-issues.md).
2. The group chat prohibits posting any information related to account sales or purchases. Group nicknames must not contain any purchase guidance or solicitation information.
3. This group does not sell any API products. Please do not trust or purchase API products from anyone (including administrators).
4. New API does not have a paid version.
5. This project must be used in compliance with relevant laws and regulations. Discussion of any illegal topics is prohibited.

!!! tip "Friendly Reminder"
    If you have any feature suggestions or bug feedback, it is recommended to submit an issue directly on GitHub, as this allows for better tracking and resolution of problems.

## 🤝 Join Our QQ Communication Group

!!! info "Please Complete the Quiz Before Joining"
    After carefully reading the group rules above, please complete the following quiz verification. The QQ group information will only be displayed if all questions are answered correctly.

<div id="quizContainer" style="margin: 20px 0;">
    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">1. What is New API?</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="a" style="margin-right: 8px;">
            <span>A commercial API sales platform</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="b" style="margin-right: 8px;">
            <span>An open-source AI interface management and distribution system</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="c" style="margin-right: 8px;">
            <span>A paid software product</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q1" value="d" style="margin-right: 8px;">
            <span>A public service API site</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">2. Can account or API product purchase requests be posted in the group?</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q2" value="true" style="margin-right: 8px;">
            <span>Yes</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q2" value="false" style="margin-right: 8px;">
            <span>No</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">3. Does New API have a paid version?</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q3" value="true" style="margin-right: 8px;">
            <span>A paid version exists</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q3" value="false" style="margin-right: 8px;">
            <span>No paid version exists; it is completely free and open source</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">4. Are the group owner and administrators obligated to provide me with technical support?</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q4" value="true" style="margin-right: 8px;">
            <span>They are obligated to provide technical support</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q4" value="false" style="margin-right: 8px;">
            <span>They are not obligated to provide technical support; issues should be submitted</span>
        </label>
    </div>

    <div style="margin-bottom: 20px; padding: 15px; background: var(--md-code-bg-color); border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 10px;">5. Can API products sold by administrators be purchased within the group?</p>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q5" value="true" style="margin-right: 8px;">
            <span>Yes, they can be purchased</span>
        </label>
        <label style="display: block; margin: 8px 0; cursor: pointer;">
            <input type="radio" name="q5" value="false" style="margin-right: 8px;">
            <span>No, this group does not sell any API products</span>
        </label>
    </div>

    <div id="quizError" style="display: none; padding: 12px; background: #ffebee; color: #c62828; border-radius: 4px; margin-bottom: 15px; border-left: 4px solid #c62828;">
        <strong>⚠️ Incorrect Answer!</strong><br>
        <span id="errorMessage">Please read the group rules carefully and try again.</span>
    </div>

    <button id="submitQuiz" style="width: 100%; padding: 12px 20px; background: #1976d2; color: white; border: none; border-radius: 4px; font-size: 15px; font-weight: 500; cursor: pointer; transition: background 0.3s;">
        Submit Answers
    </button>
</div>

<div id="qqGroupInfo" style="display: none; opacity: 0; transition: opacity 0.3s ease-in; margin-top: 20px;">
    <h3>Method 1: Scan the QR Code</h3>
    <p><img src="/assets/qq_3.jpg" alt="QQ Group QR Code" style="max-width: 300px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);"></p>
    <h3>Method 2: Click the Link</h3>
    <p><a href="https://qm.qq.com/q/Y79glR8raU" target="_blank" style="display: inline-block; padding: 10px 20px; background: #1976d2; color: white; text-decoration: none; border-radius: 4px; font-weight: 500;">Click here to join the QQ group directly</a></p>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const submitBtn = document.getElementById('submitQuiz');
    const qqGroupInfo = document.getElementById('qqGroupInfo');
    const quizError = document.getElementById('quizError');
    const errorMessage = document.getElementById('errorMessage');
    const quizContainer = document.getElementById('quizContainer');
    
    // Correct Answers
    const correctAnswers = {
        q1: 'b',  // New API 是开源的 AI 接口管理与分发系统
        q2: 'false',  // 不可以发布求购信息
        q3: 'false',  // 不存在收费版本
        q4: 'false',  // 没有义务提供技术支持
        q5: 'false'   // 不可以购买 API 产品
    };
    
    // Error Messages
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