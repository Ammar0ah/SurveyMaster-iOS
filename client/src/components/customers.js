import React, { Component } from 'react';
import './customers.css';

class Customers extends Component {
  constructor() {
    super();
    this.state = {
      customers: []
    };
  }

  componentDidMount() {
    this.callApi();
  }
  callApi = async () =>{
    try{
      let res = await fetch('/api');
      let body = await res.json();
      console.log(body);
    }
    catch(e){
      console.log(e.message);
    }
  }
  render() {
    return (
      <div>
        <h2>Customers</h2>
      </div>
    );
  }
}

export default Customers;
