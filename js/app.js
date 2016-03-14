
var form = {},
    div_erro = {},
    conteudo = {};

function processForm(e) {
  div_erro.innerHTML = "";
  if (e.preventDefault) e.preventDefault();

  var usuario = document.getElementsByName("usuario")[0].value,
      senha = document.getElementsByName("senha")[0].value;

  if(usuario === "admin" && senha === "admin"){
    conteudo.innerHTML = '<object type="text/html" data="/view/usuarios.html" ></object>';
  }else{
    div_erro.innerHTML = "<p>Usuário ou senha inválidos!</p>";
  }

  return false;
}

window.onload=function() {

  form = document.getElementById("form_login");
  div_erro = document.getElementById("erro_div");
  conteudo = document.getElementById("conteudo");

  if (form.attachEvent) {
    form.attachEvent("submit", processForm);
  } else {
    form.addEventListener("submit", processForm);
  }

};