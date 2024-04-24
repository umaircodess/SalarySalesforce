import { LightningElement, track } from "lwc";
import getsObjects from "@salesforce/apex/dynamicapex.getAllObjects";
import getChildren from "@salesforce/apex/dynamicapex.getChildren";
import retrieveRecords from "@salesforce/apex/dynamicapex.retrieveRecords";
export default class DynamicApex extends LightningElement {
  parentoptions = [];
  childoptions = [];
  @track data = [];
  apiname;
  showchild = false;
  id;
  columns = [
    { label: "Id", fieldName: "Id" },
    { label: "Name", fieldName: "Name" },
    {
      label: "Action",
      type: "button",
      initialWidth: 135,
      typeAttributes: {
        label: "View",
        title: "Click to View Details"
      }
    }
  ];

  handleRowAction(event) {
    this.id = event.detail.row.Id;
    this.showchild = true;
  }
  hidechild() {
    this.showchild = false;
  }
  connectedCallback() {
    getsObjects()
      .then((result) => {
        this.parentoptions = result.map((item) => ({
          label: item.MasterLabel,
          value: item.QualifiedApiName
        }));
      })
      .catch((error) => {
        console.log(error);
      });
  }

  handleparent(event) {
    let apiname = event.detail.value.toString();
    getChildren({ objectType: apiname })
      .then((result) => {
        this.childoptions = result.map((item) => ({
          label: item,
          value: item
        }));
      })
      .catch((error) => {
        console.log(error);
      });
  }

  handlechild(event) {
    this.apiname = event.detail.value.toString();
    retrieveRecords({ objectType: this.apiname })
      .then((result) => {
        this.data = result;
      })
      .catch((error) => {
        console.log(error);
      });
  }
}