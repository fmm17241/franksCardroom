﻿using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;

namespace NAVODatabaseAdapter
{
    public static class NAVOExtractionProgram
    {
        public async static Task<string> Execute(string extractionProgramPath, string commandArgs, string workingDirectory)
        {
            if (!File.Exists(extractionProgramPath)) throw new FileNotFoundException(string.Format("Could not locate specifed extraction program {0}", extractionProgramPath));

            var process = new Process
            {
                StartInfo = new ProcessStartInfo(extractionProgramPath)
                {
                    CreateNoWindow = true,
                    UseShellExecute = false,
                    RedirectStandardInput = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    Arguments = commandArgs,
                    WorkingDirectory = workingDirectory,
                },
            };
            process.Start();
            if (process.HasExited)
            {
                //Debug.WriteLine("{0}: {1} has completed early", DateTime.Now, Path.GetFileNameWithoutExtension(extractionProgramPath));
                return process.StandardOutput.ReadToEnd();
            }
// ReSharper disable EmptyGeneralCatchClause
            try { process.PriorityClass = ProcessPriorityClass.Idle; } catch {}
// ReSharper restore EmptyGeneralCatchClause
            while (!process.HasExited) await Task.Delay(50);
            //Debug.WriteLine("{0}: {1} has completed", DateTime.Now, Path.GetFileNameWithoutExtension(extractionProgramPath));
            return process.StandardOutput.ReadToEnd();
        }
    }
}