///watch list stuff////////////////////////////
addToWatchlist = () => {
       fetch(`http://localhost:3000/stocks`, {
           method: ‘POST’,
           headers: {
               “Content-Type”: “application/json”,
           },
           body: JSON.stringify({
               name: this.state.stock.companyName,
               price: this.state.stock.latestPrice,
               ticker: this.state.stock.symbol
           }),
       })
       .then(res => res.json())
       .then(data => {
           fetch(`http://localhost:3000/watchlists`, {
               method: ‘POST’,
               headers: {
                   “Content-Type”: “application/json”,
               },
               body: JSON.stringify({
                   user_id: this.props.user.id,
                   stock_id: data.id
               }),
           })
       })
   }



   //////////charts function
   getData = (time, search, title) => {
        let close = []
        let date = []
        fetch(`https://api.iextrading.com/1.0/stock/${search}/quote`)
            .then(res => res.json())
            .then(stock => this.setState({
                stock: stock
            }))
        fetch(`https://api.iextrading.com/1.0/stock/${search}/chart/${time}`)
            .then(res => res.json())
            .then(data => {
                data.map(p => {
                    close.push(p.close)
                    time === "1d" ? date.push(p.minute) : date.push(p.date)
                })
                this.setState({
                    data: close,
                    date: date
                })
            })
            .then(() => {
                this.setState({
                    chart: {
                        labels: this.state.date,
                        datasets: [{
                            label: title,
                            backgroundColor: "rgba(75,192,192,0.4)",
                            data: this.state.data,
                            lineTension: 0.0,
                            fill: false,
                            borderColor: "rgba(75,192,192,1)",
                            pointHoverRadius: 2,
                            pointHoverBackgroundColor: "rgba(75,192,192,1)",
                            pointHoverBorderColor: "rgba(220,220,220,1)",
                            pointHoverBorderWidth: 2,
                            pointRadius: 0,
                            pointHitRadius: 2
                        }]
                    }
                })
            })
        this.setState({
            search: "",
            data: [],
            date: []
        })
    }




///long chart code
import React from 'react'
import Stock from './Stock'
import { connect } from 'react-redux';
import { Route } from 'react-router-dom'
import { Line } from 'react-chartjs-2'
import '../App.css';
class Research extends React.Component {
    state={
        currentSearch: "",
        search: "",
        stock: {},
        data: [],
        date: [],
        chart: {}
    }
    changeHandler = (e) => {
        this.setState({
            search: e.target.value,
            currentSearch: e.target.value
        })
    }
    submitHandler = (e) => {
        e.preventDefault()
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.search}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.search}/chart/5y`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.date]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Past 5 Years",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
        this.setState({
            search: "",
            data: [],
            date: []
        })
    }
    oneDay = () => {
         this.setState({
            data: [],
            date: []
        })
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/chart/1d`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.minute]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Yesterday",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
    }
    oneMonth = () => {
         this.setState({
            data: [],
            date: []
        })
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/chart/1m`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.date]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Past Month",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
    }
    threeMonth = () => {
         this.setState({
            data: [],
            date: []
        })
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/chart/3m`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.date]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Past Three Months",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
    }
    sixMonth = () => {
         this.setState({
            data: [],
            date: []
        })
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/chart/1d`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.date]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Yesterday",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
    }
    oneYear = () => {
         this.setState({
            data: [],
            date: []
        })
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/chart/1y`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.date]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Past Year",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
    }
    twoYear = () => {
         this.setState({
            data: [],
            date: []
        })
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/chart/2y`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.date]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Past two Years",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
    }
    fiveYear = () => {
         this.setState({
            data: [],
            date: []
        })
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/quote`)
        .then(res => res.json())
        .then(stock => this.setState({stock: stock}))
        fetch(`https://api.iextrading.com/1.0/stock/${this.state.currentSearch}/chart/5y`)
        .then(res => res.json())
        .then(data => { data.map(p => {
                    this.setState({
                        data: [...this.state.data, p.close],
                        date: [...this.state.date, p.date]
                    })
                }
            )
        })
        .then(() => {
            this.setState({
                chart: {
                    labels: this.state.date,
                    datasets: [{
                        label: "Closing Price Past Five Years",
                        backgroundColor: "rgba(75,192,192,0.4)",
                        data: this.state.data,
                        lineTension: 0.0,
                        fill: false,
                        borderColor: "rgba(75,192,192,1)",
                        pointHoverRadius: 2,
                        pointHoverBackgroundColor: "rgba(75,192,192,1)",
                        pointHoverBorderColor: "rgba(220,220,220,1)",
                        pointHoverBorderWidth: 2,
                        pointRadius: 0,
                        pointHitRadius: 2
                    }]
                }
            })
        })
    }
    render(){
        console.log(this.state.chart)
        return (
        <div>
            <form onSubmit={this.submitHandler}>
                <input type="text" value={this.state.search} onChange={this.changeHandler}/>
                <button type="submit">Search</button>
            </form>
            {Object.keys(this.state.stock).length > 0 ? <button onClick={this.oneDay}>1 Day</button> : null}
            {Object.keys(this.state.stock).length > 0 ? <button onClick={this.oneMonth}>1 Month</button> : null}
            {Object.keys(this.state.stock).length > 0 ? <button onClick={this.threeMonth}>3 Months</button> : null}
            {Object.keys(this.state.stock).length > 0 ? <button onClick={this.sixMonth}>6 Months</button> : null}
            {Object.keys(this.state.stock).length > 0 ? <button onClick={this.oneYear}>1 Year</button> : null}
            {Object.keys(this.state.stock).length > 0 ? <button onClick={this.twoYear}>2 Year</button> : null}
            {Object.keys(this.state.stock).length > 0 ? <button onClick={this.fiveYear}>5 Year</button> : null}
            {Object.keys(this.state.stock).length > 0 ? <Stock stock={this.state.stock}/> : null}
            <div style={{position:"relative", width:1300, height: 1000 }} >
                {Object.keys(this.state.stock).length > 0 ? <Line ref="chart" data={this.state.chart} /> : <div class="ping">...</div>}
            </div>
        </div> 
        )
    }
}
const mapStateToProps = (state) => {
    return {
        user: state.user
    }
};
export default connect(mapStateToProps)(Research)



///////mychart function

const dateData = [
  "2014-05-12",
  "2014-05-13",
  "2014-05-14",
  "2014-05-15",
  "2014-05-19",
  "2014-05-20",
  "2014-05-21"
];
const myVolume = [
  53324674,
  39934592,
  47428583,
  56813940,
  47933075,
  43033925,
  58991505
];

const data = {
  labels: [...dateData],
  datasets: [
    {
      label: "Apple First 7 Day Volume",
      fill: false,
      lineTension: 0.1,
      backgroundColor: "rgba(75,192,192,0.4)",
      borderColor: "rgba(75,192,192,1)",
      borderCapStyle: "butt",
      borderDash: [],
      borderDashOffset: 0.0,
      borderJoinStyle: "miter",
      pointBorderColor: "rgba(75,192,192,1)",
      pointBackgroundColor: "#fff",
      pointBorderWidth: 1,
      pointHoverRadius: 5,
      pointHoverBackgroundColor: "rgba(75,192,192,1)",
      pointHoverBorderColor: "rgba(220,220,220,1)",
      pointHoverBorderWidth: 2,
      pointRadius: 1,
      pointHitRadius: 10,
      data: [...myVolume]
    }
  ]
};