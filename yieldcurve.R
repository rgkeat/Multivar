install.packages(c("YieldCurve", "quantmod", "odbc","getPass","read_csv"))
require(YieldCurve)
require(quantmod)
require(odbc)
require(getPass)
#require(read_csv)

data(ECBYieldCurve)
mat.ECB <- c(3/12,0.5,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30)

first(ECBYieldCurve, '1 month')
Nelson.Siegel(first(ECBYieldCurve, '1 month'), mat.ECB)

for (n in seq(from=70, to=290, by=10)) {
  ECB.NS <- Nelson.Siegel(ECBYieldCurve[n,], mat.ECB)
  ECB.S <- Svensson(ECBYieldCurve[n,], mat.ECB)
  ECB.NS.yield.curve <- NSrates(ECB.NS, mat.ECB)
  ECB.S.yield.curve <- Srates(ECB.S, mat.ECB, "Spot")
  plot(mat.ECB, as.numeric(
    ECBYieldCurve[n,]), type="o", lty=1, col=1, ylab="Interest rates", xlab="Maturity in years", ylim=c(3.2,4.8))
  lines(mat.ECB, as.numeric(
    ECB.NS.yield.curve), type="l", lty=3, col=2, lwd=2)
  lines(mat.ECB, as.numeric(
    ECB.S.yield.curve), type="l", lty=2, col=6, lwd=2)
  title(main=pase("ECB yield curve observed at", time(ECBYieldCurve[n], sep=" "), "vs fitted yield curve"))
  legend('bottomright', legend=c("ECB data","Nelson--Siegel","Svensson"),col=c(1,2,6), lty=1, bg='gray90')
  grid();Sys.sleep(2.5)
}

Sys.setenv(HTTPS_PROXY='http://proxy.jpmchase.net:8443')
biportal <- dbConnect(odbc()
            ,Driver = 'ODBC Driver 18 for SQL Server'
            ,Server = 'wf-1086757f82.gssdb.gmssql.jpmchase.net,16001'
            ,Trusted_Connection = 'yes'
)
lead_data <-
  dbGetQuery(
    biportal
    ,read_file(
      "/Users/rgkeat/Downloads/env/SQL_Execution.sql"
    )
  )
