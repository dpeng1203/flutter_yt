package com.soyea.rycdkh.slb

import android.app.Dialog
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.util.DisplayMetrics
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.FrameLayout
import androidx.annotation.NonNull
import com.qubian.mob.QbManager.*
import com.qubian.mob.bean.QbData
import com.qubian.mob.utils.RequestPermission
import com.qubian.mob.utils.ValueUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor(), "com.qubian.mob").setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "init") {
            init(ValueUtils.getString(call.arguments))
        }
        if (call.method == "loadSplash") {
            loadSplash(ValueUtils.getString(call.arguments), result)
        }
        if (call.method == "loadInteraction") {
            loadInteraction(ValueUtils.getString(call.arguments), result)
        }
        if (call.method == "loadRewardVideo") {
            val arguments: List<String> = ValueUtils.getValue(call.arguments, ArrayList())
            loadRewardVideo(arguments[0], arguments[1], result)
        }
        if (call.method == "loadDrawFeed") {
            loadDrawFeed(ValueUtils.getString(call.arguments), result)
        }
    }

    private fun loadSplash(codeId: String, result: MethodChannel.Result) {
        val dialog = Dialog(this, R.style.TransparentDialogStyle)
        dialog.setContentView(R.layout.dialog_fullscreen)
        val mContainer: FrameLayout = dialog.findViewById(R.id.mContainer)
        dialog.show()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(false)
        dialog.getWindow()!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog.getWindow()!!.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        loadSplash(codeId, "", "", this, mContainer, object : SplashLoadListener() {
            override fun onFail(s: String) {
                dialog.dismiss()
            }

            override fun onDismiss() {
                dialog.dismiss()
            }

            override fun onExposure() {}
            override fun onClicked() {}
        })
    }

    private fun loadInteraction(codeId: String, result: MethodChannel.Result) {
        val manager: WindowManager = this.windowManager
        val outMetrics = DisplayMetrics()
        manager.getDefaultDisplay().getMetrics(outMetrics)
        val width: Int = outMetrics.widthPixels
        loadInteraction(codeId, "", "", width, this, object : InteractionLoadListener() {
            override fun onFail(s: String) {}
            override fun onDismiss() {}
            override fun onClicked() {}
            override fun onExposure() {}
            override fun onVideoReady() {}
            override fun onVideoComplete() {
                //返回给flutter的参数
                result.success("1")
            }
        })
    }

    //VERTICAL||HORIZONTAL
    private fun loadRewardVideo(codeId: String, orientation: String, result: MethodChannel.Result) {
        val rvAdOrientation: Orientation
        rvAdOrientation = if ("HORIZONTAL" == orientation) {
            Orientation.VIDEO_HORIZONTAL
        } else {
            Orientation.VIDEO_VERTICAL
        }
        loadPlayRewardVideo(codeId, "", "", "", "", rvAdOrientation, this, object : RewardVideoLoadListener() {
            override fun onFail(s: String) {}
            override fun onClick() {}
            override fun onClose() {}
            override fun onExposure(orderNo: String) {}
            override fun onRewardVideoCached(qbData: QbData) {}
            override fun onRewardVerify() {
                //返回给flutter的参数
                result.success("1")
            }
        })
    }

    private fun loadDrawFeed(codeId: String, result: MethodChannel.Result) {
        val dialog = Dialog(this)
        dialog.setContentView(R.layout.dialog_fullscreen)
        val mContainer: FrameLayout = dialog.findViewById(R.id.mContainer)
        dialog.show()
        dialog.setCancelable(false)
        dialog.setCanceledOnTouchOutside(true)
        dialog.getWindow()!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog.getWindow()!!.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        loadDrawFeed(codeId, "", "", 0, this, mContainer, object : DrawFeedLoadListener() {
            override fun onFail(s: String) {}
            override fun onClicked() {}
            override fun onRenderFail() {}
            override fun onRenderSuccess() {}
        })
    }

    private fun init(appId: String) {
        init(this, appId) //SDK初始化
        RequestPermission.RequestPermissionIfNecessary(this) //动态权限
    }
}


