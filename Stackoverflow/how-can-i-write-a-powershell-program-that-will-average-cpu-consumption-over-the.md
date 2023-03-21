# How can I write a PowerShell program that will Average CPU consumption over the time range of 15 minutes

## Original question

> How can I write a PowerShell program that will Average CPU consumption over the time range of 15 minutes?
>
> Below is my sample command
>
>
> ```powershell
> Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select Average | Out-File c:\RM.txt -Encoding utf8
> ```

PowerShell program that will Average CPU consumption over the time range of 15 minutes

## My solution

If you want to measure CPU usage over a period of time, you should use `Get-Counter`.

The example below measures the CPU usage of a system for 15 minutes (900 seconds) and gets the average from all the samples:

```powershell
Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 MaxSamples 900  | Select-Object -ExpandProperty countersamples | Select-Object -ExpandProperty CookedValue | Measure-Object -Average
```

Usually, getting a sample every 5 seconds is sufficient so you could also do this:

```powershell
Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 5 MaxSamples 180  | Select-Object -ExpandProperty countersamples | Select-Object -ExpandProperty CookedValue | Measure-Object -Average
```

This will get the cpu usage every 5 seconds and gets 180 samples in total, resulting in 900 seconds/15 minutes.

## Reference

[How can I write a PowerShell program that will Average CPU consumption over the time range of 15 minutes | StackOverflow](https://stackoverflow.com/questions/75799163/how-can-i-write-a-powershell-program-that-will-average-cpu-consumption-over-the#75799163)