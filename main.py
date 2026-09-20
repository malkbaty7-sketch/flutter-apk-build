#!/usr/bin/env python3
"""
كاتب - نظام بناء APK التلقائي

هذا السكريبت يقوم ب:
1. استلام طلب بناء APK عبر GitHub Repository Dispatch
2. تفعيل GitHub Actions workflow لبناء التطبيق
3. متابعة حالة البناء وعرض رابط التنزيل
"""

import os
import sys
import json
import time
import requests
import subprocess
from datetime import datetime
from typing import Optional, Dict, Any

# متغيرات البيئة
GH_TOKEN = os.getenv('GH_TOKEN')
GH_USER = os.getenv('GH_USER', 'malkbaty7-sketch')
GH_REPO = os.getenv('GH_REPO', 'flutter-apk-build')
GITHUB_API_URL = f"https://api.github.com/repos/{GH_USER}/{GH_REPO}"


def log(message: str, level: str = "INFO") -> None:
    """سجل رسالة مع طابع زمني"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp}] [{level}] {message}")


def check_environment() -> bool:
    """تحقق من وجود المتغيرات البيئة الضرورية"""
    if not GH_TOKEN:
        log("GH_TOKEN غير معرف. يرجى تعيينة في بيئة التنفيذ", "ERROR")
        return False
    return True


def trigger_github_actions_workflow(workflow_file: str = "build.yml", 
                                   ref: str = "main") -> Optional[Dict[str, Any]]:
    """
    تفعيل workflow في GitHub Actions
    
    Args:
        workflow_file: اسم ملف workflow (مثل build.yml)
        ref: الفرع أو التاج (af68d9 default main)
    
    Returns:
        Dict: معلومات عن طلب التفعيل
    """
    url = f"{GITHUB_API_URL}/actions/workflows/{workflow_file}/dispatches"
    
    headers = {
        "Authorization": f"token {GH_TOKEN}",
        "Accept": "application/vnd.github.v3+json",
        "Content-Type": "application/json"
    }
    
    payload = {
        "ref": ref,
        "inputs": {}
    }
    
    try:
        response = requests.post(url, headers=headers, data=json.dumps(payload))
        
        if response.status_code == 204:
            log(f"تم تفعيل workflow {workflow_file} بنجاح")
            return {"status": "success", "workflow": workflow_file}
        else:
            log(f"فشل تفعيل workflow: {response.status_code} - {response.text}", "ERROR")
            return None
    except Exception as e:
        log(f"خطأ في الاتصال بـ GitHub API: {str(e)}", "ERROR")
        return None


def get_latest_workflow_run(workflow_file: str = "build.yml") -> Optional[Dict[str, Any]]:
    """
    الحصول على آخر تشغيل للworkflow
    
    Args:
        workflow_file: اسم ملف workflow
    
    Returns:
        Dict: معلومات عن آخر تشغيل
    """
    url = f"{GITHUB_API_URL}/actions/workflows/{workflow_file}/runs"
    
    headers = {
        "Authorization": f"token {GH_TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    params = {
        "per_page": 1
    }
    
    try:
        response = requests.get(url, headers=headers, params=params)
        
        if response.status_code == 200:
            runs = response.json()
            if runs['workflow_runs']:
                return runs['workflow_runs'][0]
        else:
            log(f"فشل الحصول على معلومات workflow: {response.status_code}", "ERROR")
        return None
    except Exception as e:
        log(f"خطأ في الحصول على معلومات workflow: {str(e)}", "ERROR")
        return None


def monitor_workflow_run(run_id: int, timeout: int = 3600) -> Optional[Dict[str, Any]]:
    """
    متابعة حالة تشغيل workflow
    
    Args:
        run_id: معرف تشغيل workflow
        timeout: وقت الانتظار الأقصى بالثواني
    
    Returns:
        Dict: الحالة النهائية لتشغيل workflow
    """
    url = f"{GITHUB_API_URL}/actions/runs/{run_id}"
    
    headers = {
        "Authorization": f"token {GH_TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    start_time = time.time()
    
    while time.time() - start_time < timeout:
        try:
            response = requests.get(url, headers=headers)
            
            if response.status_code == 200:
                run_info = response.json()
                status = run_info.get('status')
                conclusion = run_info.get('conclusion')
                
                log(f"حالة البناء: {status} | نتيجة: {conclusion}")
                
                # إذا انتهى البناء
                if status == 'completed':
                    return run_info
                
                # إذا فشل أو تم إلغاؤه
                if conclusion in ['failure', 'cancelled', 'timed_out']:
                    log(f"انتهى البناء بحالة: {conclusion}", "ERROR")
                    return run_info
                
                # انتظار قبل المحاولة مرة أخرى
                time.sleep(10)
            else:
                log(f"فشل الحصول على حالة البناء: {response.status_code}", "ERROR")
                time.sleep(10)
                
        except Exception as e:
            log(f"خطأ في متابعة البناء: {str(e)}", "ERROR")
            time.sleep(10)
    
    log("انتهى وقت الانتظار دون اكتمال البناء", "ERROR")
    return None


def get_artifact_download_url(run_id: int) -> Optional[str]:
    """
    الحصول على رابط تنزيل artifact
    
    Args:
        run_id: معرف تشغيل workflow
    
    Returns:
        str: رابط تنزيل artifact
    """
    url = f"{GITHUB_API_URL}/actions/runs/{run_id}/artifacts"
    
    headers = {
        "Authorization": f"token {GH_TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    try:
        response = requests.get(url, headers=headers)
        
        if response.status_code == 200:
            artifacts = response.json()
            if artifacts['artifacts']:
                # الحصول على أول artifact (عادة release-apk)
                artifact = artifacts['artifacts'][0]
                return artifact['archive_download_url']
        else:
            log(f"فشل الحصول على artifacts: {response.status_code}", "ERROR")
        return None
    except Exception as e:
        log(f"خطأ في الحصول على artifact: {str(e)}", "ERROR")
        return None


def build_apk() -> Dict[str, Any]:
    """
    عملية بناء APK الكاملة
    
    Returns:
        Dict: معلومات عن عملية البناء
    """
    result = {
        "success": False,
        "message": "",
        "workflow_run_id": None,
        "artifact_url": None,
        "status": "pending"
    }
    
    if not check_environment():
        result["message"] = "بيئة غير صالحة"
        return result
    
    try:
        # 1. تفعيل workflow
        log("بدء تفعيل workflow...")
        workflow_result = trigger_github_actions_workflow()
        
        if not workflow_result:
            result["message"] = "فشل تفعيل workflow"
            return result
        
        # انتظار قليلا قبل التحقق
        time.sleep(5)
        
        # 2. الحصول على آخر تشغيل
        log("الحصول على معلومات البناء...")
        latest_run = get_latest_workflow_run()
        
        if not latest_run:
            result["message"] = "فشل الحصول على معلومات البناء"
            return result
        
        run_id = latest_run['id']
        result["workflow_run_id"] = run_id
        
        # 3. متابعة البناء
        log(f"متابعة البناء (ID: {run_id})...")
        final_run = monitor_workflow_run(run_id)
        
        if not final_run:
            result["message"] = "فشل متابعة البناء"
            return result
        
        # 4. التحقق من النتيجة
        conclusion = final_run.get('conclusion')
        
        if conclusion == 'success':
            result["success"] = True
            result["status"] = "completed"
            result["message"] = "تم بناء APK بنجاح"
            
            # الحصول على رابط التنزيل
            artifact_url = get_artifact_download_url(run_id)
            if artifact_url:
                result["artifact_url"] = artifact_url
                log(f"رابط تنزيل APK: {artifact_url}")
            else:
                log("لم يتم العثور على artifact", "WARNING")
                result["message"] = "تم البناء لكن لم يتم العثور على ملف APK"
        else:
            result["message"] = f"فشل البناء: {conclusion}"
            result["status"] = conclusion or "failed"
        
    except Exception as e:
        log(f"خطأ في عملية البناء: {str(e)}", "ERROR")
        result["message"] = str(e)
        result["status"] = "error"
    
    return result


def main():
    """الدالة الرئيسية"""
    print("=" * 60)
    print("  كاتب - نظام بناء APK التلقائي")
    print("=" * 60)
    print()
    
    # بدء عملية البناء
    result = build_apk()
    
    print()
    print("=" * 60)
    print("  نتائج عملية البناء")
    print("=" * 60)
    print(f"الحالة: {result.get('status', 'unknown')}")
    print(f"النجاح: {result.get('success', False)}")
    print(f"الرسالة: {result.get('message', '')}")
    
    if result.get('workflow_run_id'):
        print(f"معرف البناء: {result['workflow_run_id']}")
    
    if result.get('artifact_url'):
        print(f"رابط التنزيل: {result['artifact_url']}")
    
    print("=" * 60)
    
    # إنهاء البرنامج
    if result.get('success'):
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
