using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common
{
    public static class ProgressInfoService
    {

        static public void BeginProgressProcess()
        {
            BeginProgressProcess(true, 100);
        }

        static public void BeginProgressProcess(bool cancelSupported, int progressGranularity)
        {
            ProgressProcessEventArgs e = new ProgressProcessEventArgs(cancelSupported, progressGranularity);
            OnProgressProcessStarted(e);
        }

        static public event EventHandler<ProgressProcessEventArgs> ProgressProcessStarted;
        static private void OnProgressProcessStarted(ProgressProcessEventArgs e)
        {
            if (ProgressProcessStarted != null)
            {
                ProgressProcessStarted(null, e);
            }
        }

        static public event ProgressChangedEventHandler ProgressChanged;
        static private void OnProgressChanged(ProgressChangedEventArgs e)
        {
            if (ProgressChanged != null)
            {
                ProgressChanged(null, e);
            }
        }

        static public event EventHandler ProgressProcessEnded;
        static private void OnProgressProcessEnded()
        {
            if (ProgressProcessEnded != null)
            {
                ProgressProcessEnded(null, EventArgs.Empty);
            }
        }

        static public event CancelEventHandler ProgressCanceledQuery;

        static private void OnProgressCanceledQuery(CancelEventArgs e)
        {
            if (ProgressCanceledQuery != null)
            {
                ProgressCanceledQuery(null, e);
            }
        }

        static public void ReportProgess(int ProgressAmount, object Message)
        {
            ProgressChangedEventArgs e = new ProgressChangedEventArgs(ProgressAmount, Message);
            OnProgressChanged(e);
        }

        static public void EndProgressProcess()
        {
            OnProgressProcessEnded();
        }


    }

    public class ProgressProcessEventArgs : EventArgs
    {
        public ProgressProcessEventArgs() : this(false, 100) { }

        public ProgressProcessEventArgs(bool cancelSupported, int progressGranularity)
        {
            CancelSupported = cancelSupported;
            ProgressGranularity = progressGranularity;
        }

        public bool CancelSupported { get; private set; }
        public int ProgressGranularity { get; private set; }
    }
}
