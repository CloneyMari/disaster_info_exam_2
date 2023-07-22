import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
 static targets = ['selectedRegionId', 'selectProvinceId', 'selectCityId', 'selectBarangayId']

 fetchCities(){
  let target = this.selectCityIdTarget
  console.log(target)
  target.innerHTML =''

   $.ajax({
     type: 'GET',
     url: '/api/v1/provinces/' + this.selectProvinceIdTarget.value + '/cities',
     dataType: 'json',
     success: (response) => {
       console.log(response)
      $.each(response, function (index, record) {
        let option = document.createElement('option')
        option.value = record.id
        option.text = record.name
        target.appendChild(option)
      })
     }
   })
 }

 fetchBarangays(){
  let target = this.selectBarangayIdTarget
  target.innerHTML =''

   $.ajax({
     type: 'GET',
     url: '/api/v1/cities/' + this.selectCityIdTarget.value + '/barangays',
     dataType: 'json',
     success: (response) => {
       console.log(response)
      $.each(response, function (index, record) {
        let option = document.createElement('option')
        option.value = record.id
        option.text = record.name
        target.appendChild(option)
      })
     }
   })
 }

 fetchProvinces(){
   let target = this.selectProvinceIdTarget
   console.log(target)
   target.innerHTML =''

   $.ajax({
      type: 'GET',
      url: '/api/v1/regions/' + this.selectedRegionIdTarget.value + '/provinces',
      dataType: 'json',
      success: (response) => {
        console.log(response)
       $.each(response, function (index, record) {
         let option = document.createElement('option')
         option.value = record.id
         option.text = record.name
         target.appendChild(option)
       })
      }
    })
  }
}
