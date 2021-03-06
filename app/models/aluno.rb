class Aluno < ActiveRecord::Base
  belongs_to :escola
  belongs_to :profissao
  has_many :aulas
  has_many :matriculas
  has_many :previsoes, :as => :cliente
  has_many :turmas, :through => :aulas
  has_one :endereco_residencial, :as => :enderecavel, :class_name => 'EnderecoResidencial', :dependent => :destroy
  has_one :endereco_comercial, :as => :enderecavel, :class_name => 'EnderecoComercial', :dependent => :destroy
  validates_uniqueness_of :subscricao, :email, :cpf, :rg, :scope => :escola_id
  validates_presence_of :escola, :nome, :subscricao, :email, :sexo
  validates_inclusion_of :sexo, :in => %w( M F )

  # Retorna uma lista paginada dos alunos. 
  # Recebe:
  #   page: o numero da pagina que deve ser retornada
  #   per_page: numero de itens a retornar na lista
  def self.paginar(page, per_page = 15)
    self.paginate(:page => page, :per_page => per_page, :order => "id DESC")
  end
  
  # Pesquisa por alunos a partir de uma chave. Se a chave representar um número,
  # a pesquisa é feita por número de subscricao. Caso contrário a pesquisa é feito
  # a partir do nome dos alunos.
  # Retorna os resultados da busca de forma paginada
  #
  # Recebe:
  #   chave: A chave de pesquisa a utilizar
  def self.pesquisar_com_paginacao(chave, page, per_page = 15)
    if chave =~ /^\d+$/
      find_all_by_subscricao(chave).paginate(:page => page, :per_page => per_page)
    else
      find(:all, :conditions => ["nome like ?", "%#{chave}%"]).paginate(:page => page, :per_page => per_page)
    end
  end
  
  def initialize(*args)
  	super(*args)
  	#self.subscricao = proxima_subscricao if id.nil?
  end

  def self.find_by_nome_or_subscricao(nome_or_subscricao)
    find(:first, :conditions => ["nome like :valor OR subscricao = :valor", {:valor => nome_or_subscricao}])
  end

  def nome_ou_subscricao
    nome
  end

  def proxima_subscricao
    Integer(escola.alunos.maximum(:subscricao)) + 1 unless escola.nil?
  end
end
