package org.kepocnhh.aas.presentation.module.main

import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import org.kepocnhh.aas.App
import org.kepocnhh.aas.implementation.module.main.MainViewModel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

internal class MainActivity : AppCompatActivity() {
    @Composable
    private fun Presentation() {
        val viewModel: MainViewModel = App.viewModel()
        val timeState = rememberSaveable { mutableStateOf<Long?>(null) }
        val time = timeState.value
        Box(modifier = Modifier.fillMaxSize()) {
            if (time == null) {
                BasicText(modifier = Modifier.align(Alignment.Center), text = "loading....")
                viewModel.requestTime {
                    timeState.value = it
                }
            } else {
                BasicText(
                    modifier = Modifier.align(Alignment.Center),
                    text = SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.US).format(Date(time))
                )
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Presentation()
        }
    }
}
