﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	// Запрос коммерческого предложения у поставщика
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ЗапросКоммерческогоПредложенияОтКлиента";
	КомандаПечати.Идентификатор = "ЗапросКоммерческогоПредложенияОтКлиента";
	КомандаПечати.Представление = НСтр("ru = 'Запрос коммерческого предложения от клиента'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект;
//                                            представление - имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗапросКоммерческогоПредложенияОтКлиента");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"ЗапросКоммерческогоПредложенияОтКлиента",
				НСтр("ru = 'Запрос коммерческого предложения от клиента'"),
				ПечатьЗапросаКоммерческихПредложений(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
КонецПроцедуры

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность = ПравоДоступа("Редактирование", Метаданные.Документы.ЗапросКоммерческогоПредложенияОтКлиента);
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	КоммерческиеПредложенияДокументыПереопределяемый.ПриЗаполненииСпискаТекущихДелКоммерческихПредложений(ТекущиеДела, "ЗапросКоммерческогоПредложенияОтКлиента");
	
КонецПроцедуры

#Область КомандыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	КоммерческиеПредложенияДокументыПереопределяемый.ПриДобавленииКомандОтчетов("Документ.ЗапросКоммерческогоПредложенияОтКлиента", 
	                                                                            КомандыОтчетов,
	                                                                            Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. ЭлектронноеВзаимодействие.ПриЗаполненииСписковСОграничениемДоступа
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Документы.ЗапросКоммерческогоПредложенияОтКлиента, Истина);
	Списки.Вставить(Метаданные.Справочники.ЗапросКоммерческогоПредложенияОтКлиентаПрисоединенныеФайлы, Истина);
	
КонецПроцедуры

// См. ЭлектронноеВзаимодействие.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	КоммерческиеПредложенияДокументыПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(
		"Документ.ЗапросКоммерческогоПредложенияОтКлиента", Описание);
	КоммерческиеПредложенияДокументыПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(
		"Справочник.ЗапросКоммерческогоПредложенияОтКлиентаПрисоединенныеФайлы", Описание);

КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	КоммерческиеПредложенияДокументыПереопределяемый.ПриЗаполненииОграниченияДоступа(
		"Документ.ЗапросКоммерческогоПредложенияОтКлиента", Ограничение);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область КомандыСозданияНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании.
//      См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
// Возвращаемое значение:
//  Произвольный - новая команда.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Результат = Неопределено;
	КоммерческиеПредложенияДокументыПереопределяемый.ИнициализацияКомандФормы("ДобавитьКомандуСоздатьНаОсновании",
		Метаданные.Документы.ЗапросКоммерческогоПредложенияОтКлиента.Имя, КомандыСозданияНаОсновании, Результат);
	Возврат Результат;
	
КонецФункции

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	КоммерческиеПредложенияДокументыПереопределяемый.ИнициализацияКомандФормы("ДобавитьКомандыСозданияНаОсновании",
		Метаданные.Документы.ЗапросКоммерческогоПредложенияОтКлиента.Имя, КомандыСозданияНаОсновании, Параметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается для определения событий которые поддерживает текущая версия документа
// 
// Параметры:
//  ОбработчикиСобытийПереопределяемые - Структура - доступные события документа.
//
Процедура ОбработчикиСобытийКоммерческихПредложений(ОбработчикиСобытийПереопределяемые) Экспорт
	
	ОбработчикиСобытийПереопределяемые["СоздатьЗапросКоммерческихПредложений"] = Истина;
	
КонецПроцедуры

// Создание нового или перезаполнение существующего документа Запрос коммерческих предложений от клиента.
//
// Параметры:
//  ДанныеВходящегоДокумента - ДеревоЗначений - Данные, соответствующие структуре макета ЗапросКоммерческихПредложений
//                             обработки ОбменСКонтрагентами.
//  УчетныйДокумент          - ДокументСсылка - Ссылка на учетный документ Запрос коммерческих предложений от клиента.
//                             См. ОпределяемыйТип.ОснованияЭлектронныхДокументовЭДО.
//
Процедура НайтиСоздатьЗапросКоммерческихПредложений(Знач ДанныеВходящегоДокумента, УчетныйДокумент) Экспорт
	
	Если Не Константы.ИспользоватьЗапросыКоммерческихПредложенийОтКлиента.Получить() Тогда
		ТекстОшибки = НСтр("ru = 'Возможность использования документов ''Запрос коммерческого предложения от клиента'' отключена администратором.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Если ЗначениеЗаполнено(УчетныйДокумент) Тогда
			ДокументОбъект = ОбщегоНазначенияБЭД.ОбъектПоСсылкеДляИзменения(УчетныйДокумент);
		Иначе
			ДокументОбъект = Документы.ЗапросКоммерческогоПредложенияОтКлиента.СоздатьДокумент();
			ДокументОбъект.Дата = ТекущаяДатаСеанса();
			ДокументОбъект.УстановитьНовыйНомер();
			ДокументОбъект.Менеджер = Пользователи.ТекущийПользователь();
		КонецЕсли;
		
		ДокументОбъект.ИдентификаторСервиса = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "ИдентификаторДокумента");
		ДокументОбъект.НомерЭД              = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "Номер");
		ДокументОбъект.ДатаЭД               = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "Дата");
		
		ДокументОбъект.Валюта = ОбщегоНазначенияБЭД.НайтиСсылку("Валюты",
			Строка(ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.ВалютаКод")));
			
		РеквизитыОрганизации = КоммерческиеПредложенияДокументы.ПолучательОтправительПоДаннымЭД(ДанныеВходящегоДокумента, "Получатель");
		Организация = ОбщегоНазначенияБЭД.НайтиСсылку("Организации",,РеквизитыОрганизации);
		
		Если ЗначениеЗаполнено(Организация) Тогда
			ДокументОбъект.Организация = Организация;
		КонецЕсли;
		
		РеквизитыКонтрагента = КоммерческиеПредложенияДокументы.ПолучательОтправительПоДаннымЭД(ДанныеВходящегоДокумента, "Организация");
		Контрагент = ОбщегоНазначенияБЭД.НайтиСсылку("Контрагенты",,РеквизитыКонтрагента);
		
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			
			Отказ = Ложь;
			БизнесСетьПереопределяемый.СоздатьКонтрагентаПоРеквизитам(РеквизитыКонтрагента, Контрагент, Отказ);
			
			Если Отказ Тогда
				ТекстОшибки = НСтр("ru = 'Не удалось создать контрагента'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументОбъект.Ссылка);
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		ДокументОбъект.Контрагент = Контрагент;
		
		Если Не КоммерческиеПредложенияСлужебный.МетаданныеПоОпределяемомуТипу("ПартнерБЭД") = Неопределено Тогда
			
			КоммерческиеПредложенияДокументыПереопределяемый.ПолучитьПартнераПоКонтрагенту(Контрагент, ДокументОбъект.Клиент);
			
		КонецЕсли;
		
		Операция = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.ПриемПередачаНаКомиссию");
		
		Если Операция = Истина Тогда
			ДокументОбъект.ХозяйственнаяОперация = Перечисления.ВидыОперацийКоммерческихПредложений.ПриемНаКомиссию;
		Иначе
			ДокументОбъект.ХозяйственнаяОперация = Перечисления.ВидыОперацийКоммерческихПредложений.ЗакупкаУПоставщика;
		КонецЕсли;
		
		ДокументОбъект.МожетОбеспечиватьсяЧастично  = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.ВсеИлиНичего");
		ДокументОбъект.Налогообложение              = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.ТолькоСНДС");
		
		Если ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "АдресДоставки") Тогда
			ДокументОбъект.АдресПоставки    = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "АдресДоставки.Представление");
		КонецЕсли;
		
		//КонтактноеЛицо
		ДанныеКонтактногоЛица = КоммерческиеПредложенияДокументы.СтруктураПоГруппеДерева(ДанныеВходящегоДокумента, "КонтактноеЛицо");
		КоммерческиеПредложенияДокументыПереопределяемый.ЗаполнитьКонтактноеЛицоДокументаПоДаннымЭлектронногоДокумента(Контрагент,
		                                                                                                               ДанныеКонтактногоЛица,
		                                                                                                               ДокументОбъект.КонтактноеЛицо);
		
		ДокументОбъект.ДатаНачалаПубликации                = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.ДатаНачалаСбора");
		ДокументОбъект.ДатаОкончанияПубликации             = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.ДатаОкончанияСбора");
		ДокументОбъект.ДатаОкончанияРассмотрения           = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.ДатаОкончанияРассмотрения");
		ДокументОбъект.УсловиеДоставкиТекст                = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.УсловияДоставки");
		ДокументОбъект.УсловияОплатыТекст                  = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.УсловияОплаты");
		ДокументОбъект.ПрочаяДополнительнаяИнформацияТекст = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(ДанныеВходящегоДокумента, "УсловияИПоложения.УсловияПрочие");
		
		ДокументОбъект.Товары.Очистить();
		
		// Сведения таблицы.
		СведенияОТоварах = ДанныеВходящегоДокумента.Строки.Найти("Товары", "ПолныйПуть");
		
		Сопоставление = КоммерческиеПредложенияДокументы.СопоставлениеНоменклатурыДляДереваДокумента(
			ДокументОбъект.Контрагент, СведенияОТоварах);
			
		Для Каждого СведенияОТоваре Из СведенияОТоварах.Строки Цикл
			НоваяСтрока = ДокументОбъект.Товары.Добавить();
			
			НоваяСтрока.НоменклатураСсылка = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.Товар.НоменклатураСсылка");
			
			НоваяСтрока.ХарактеристикаСсылка = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.Товар.ХарактеристикаСсылка");
			
			НоваяСтрока.ИдентификаторСтрокиЗапроса = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.ИдентификаторСтроки");
			НоваяСтрока.НомерСтрокиЗапроса = СведенияОТоваре.Значение;
			
			НоваяСтрока.НоменклатураПокупателяПредставление = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.Товар.НоменклатураНаименование");
			
			НоваяСтрока.ИдентификаторДляСопоставленияНоменклатуры = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.Товар.ИдентификаторДляСопоставления");
			
			ЛогистическаяУпаковкаТекст = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.ЛогистическаяУпаковка.Описание");
			
			Если Не ЗначениеЗаполнено(ЛогистическаяУпаковкаТекст) Тогда
				ЛогистическаяУпаковкаТекст = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
							"Товары.НомерСтроки.Товар.ЕдиницаИзмеренияНаименование");
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ЛогистическаяУпаковкаТекст) Тогда
				ЛогистическаяУпаковкаТекст = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
							"Товары.НомерСтроки.Товар.ЕдиницаИзмеренияКодОКЕИ");
			КонецЕсли;
			
			НоваяСтрока.ЕдиницаИзмерения = ЛогистическаяУпаковкаТекст;
					
			Если ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
					"Товары.НомерСтроки.Товар.Сервис1СНоменклатура") = "Номенклатура" Тогда
				НоваяСтрока.НоменклатураВСервисеИдентификатор = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
							"Товары.НомерСтроки.Товар.Сервис1СНоменклатура.Номенклатура.ИдентификаторНоменклатуры");
				НоваяСтрока.ХарактеристикаВСервисеИдентификатор = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
							"Товары.НомерСтроки.Товар.Сервис1СНоменклатура.Номенклатура.ИдентификаторХарактеристики");
				
				Если Не ЗначениеЗаполнено(НоваяСтрока.НоменклатураСсылка) Тогда
					Номенклатура = Новый Структура;
					Номенклатура.Вставить("ИдентификаторНоменклатуры",   НоваяСтрока.НоменклатураВСервисеИдентификатор);
					Номенклатура.Вставить("ИдентификаторХарактеристики", НоваяСтрока.ХарактеристикаВСервисеИдентификатор);
					
					СопоставленнаяНоменклатура = РаботаСНоменклатурой.НоменклатураИХарактеристикиПоИдентификаторам(Номенклатура);
					
					Если СопоставленнаяНоменклатура.Количество() Тогда
						НоваяСтрока.НоменклатураСсылка = СопоставленнаяНоменклатура[0].Номенклатура;
						НоваяСтрока.ХарактеристикаСсылка = СопоставленнаяНоменклатура[0].Характеристика;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			НоваяСтрока.Количество = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.Количество");
			НоваяСтрока.МаксимальнаяЦена = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
						"Товары.НомерСтроки.Цена");
			
			Если ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,"Товары.НомерСтроки.СрокПоставки") = "" Тогда
				ДокументОбъект.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается;
			ИначеЕсли ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,"Товары.НомерСтроки.СрокПоставки") = "НаДату" Тогда
				ДокументОбъект.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату;
				НоваяСтрока.СрокПоставки = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
							"Товары.НомерСтроки.СрокПоставки.НаДату");
			Иначе
				ДокументОбъект.ВариантУказанияСрокаПоставки = Перечисления.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа;
				НоваяСтрока.СрокПоставки = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
							"Товары.НомерСтроки.СрокПоставки.ВДнях");
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(НоваяСтрока.НоменклатураСсылка) Тогда
				ЭлементСопоставления = Сопоставление.Найти(НоваяСтрока.ИдентификаторДляСопоставленияНоменклатуры,
					"НоменклатураПоставщикаИдентификатор");
				
				Если ЭлементСопоставления <> Неопределено Тогда
					НоваяСтрока.НоменклатураСсылка = ЭлементСопоставления.Номенклатура;
					НоваяСтрока.ХарактеристикаСсылка = ЭлементСопоставления.Характеристика;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		ДокументОбъект.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Заполнение запроса коммерческих предложений'"),
			ПодробноеПредставлениеОшибки(Информация),
			НСтр("ru = 'Не удалось заполнить документ запрос коммерческих предложений'"));
		
		Возврат;
		
	КонецПопытки;
	
	УчетныйДокумент = ДокументОбъект.Ссылка;
	
	СоответствиеФайлов = Новый Соответствие;
	СведенияОФайлах = ДанныеВходящегоДокумента.Строки.Найти("ПрисоединенныеФайлы", "ПолныйПуть");
	
	ТаблицаИменФайлов = Новый ТаблицаЗначений;
	ТаблицаИменФайлов.Колонки.Добавить("ИмяБезРасширения", Новый ОписаниеТипов("Строка"));
	
	Если ЗначениеЗаполнено(СведенияОФайлах.Значение) Тогда
		
		Для Каждого СведенияОТоваре Из СведенияОФайлах.Строки Цикл
			
			АдресДанныхФайла = ПоместитьВоВременноеХранилище(
			ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
				"ПрисоединенныеФайлы.НомерСтроки.ДвоичныеДанные"), Новый УникальныйИдентификатор);
			
			ИмяБезРасширения = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
				"ПрисоединенныеФайлы.НомерСтроки.ИмяФайла");
			
			РасширениеФайла = ЭлектронноеВзаимодействие.ЗначениеРеквизитаВДереве(СведенияОТоваре,
				"ПрисоединенныеФайлы.НомерСтроки.РасширениеФайла");
			
			ПараметрыФайла = Новый Структура();
			ПараметрыФайла.Вставить("Автор"                          , Пользователи.ТекущийПользователь());
			ПараметрыФайла.Вставить("ИмяБезРасширения"               , ИмяБезРасширения);
			ПараметрыФайла.Вставить("РасширениеБезТочки"             , РасширениеФайла);
			ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное"    , ТекущаяУниверсальнаяДата());
			ПараметрыФайла.Вставить("ВладелецФайлов"                 , УчетныйДокумент);
			ПараметрыФайла.Вставить("АдресФайлаВоВременномХранилище" , АдресДанныхФайла);
			ПараметрыФайла.Вставить("АдресВременногоХранилищаТекста" , Неопределено);
			
			СоответствиеФайлов.Вставить(ИмяБезРасширения, ПараметрыФайла);
			
			НоваяСтрока = ТаблицаИменФайлов.Добавить();
			НоваяСтрока.ИмяБезРасширения = ИмяБезРасширения;
			
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Истина);
		
		ТаблицаФайлов = ПолучитьФайлыДляИзменения(ТаблицаИменФайлов, УчетныйДокумент);
		
		Для Каждого Файл Из ТаблицаФайлов Цикл
			
			Если ЗначениеЗаполнено(Файл.СсылкаНаФайл) Тогда
				Файл.СсылкаНаФайл.ПолучитьОбъект().УстановитьПометкуУдаления(Файл.ПометкаУдаления);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Файл.ИмяБезРасширения) Тогда
				ПараметрыФайла = СоответствиеФайлов.Получить(Файл.ИмяБезРасширения);
				
				Если ПараметрыФайла = Неопределено Тогда 
					ВызватьИсключение НСтр("ru = 'Не удалось найти присоединяемый файл для создания'");
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Файл.СсылкаНаФайл) Тогда
					РаботаСФайлами.ОбновитьФайл(Файл.СсылкаНаФайл, ПараметрыФайла);
				Иначе
					РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, ПараметрыФайла.АдресФайлаВоВременномХранилище);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	КоммерческиеПредложенияСлужебный.УстановитьСтатусЗапросаВПоиске(УчетныйДокумент.ИдентификаторСервиса, Перечисления.СтатусыЗапросаКоммерческихПредложенийДляПоиска.ОтложенДляОтвета);
КонецПроцедуры

Процедура ОпределитьСписокОперацийЭлектронногоДокумента(СписокОпераций) Экспорт
	
	СписокОпераций.Добавить("ЗапросКоммерческогоПредложенияОтКлиента",
		НСтр("ru = 'Запрос коммерческого предложения от клиента'"), Истина);
	
КонецПроцедуры

// Формирует представление документа-основания, в случае, если документом основанием является запрос.
//
// Параметры:
//  ЗапросКоммерческогоПредложения - ДокументСсылка - ссылка на документ-основание.
//
// Возвращаемое значение:
//   Строка.
//
Функция ДанныеДокументаДляФормированияПредставления(ЗапросКоммерческогоПредложения) Экспорт
	
	ДанныеЗапроса = Новый Структура;
	ДанныеЗапроса.Вставить("ДатаОкончанияПубликации",   Неопределено);
	ДанныеЗапроса.Вставить("ДатаОкончанияРассмотрения", Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗапросКоммерческогоПредложенияОтКлиента.ДатаОкончанияПубликации   КАК ДатаОкончанияПубликации,
	|	ЗапросКоммерческогоПредложенияОтКлиента.ДатаОкончанияРассмотрения КАК ДатаОкончанияРассмотрения
	|ИЗ
	|	Документ.ЗапросКоммерческогоПредложенияОтКлиента КАК ЗапросКоммерческогоПредложенияОтКлиента
	|ГДЕ
	|	ЗапросКоммерческогоПредложенияОтКлиента.Ссылка = &ЗапросКоммерческогоПредложения";
	
	Запрос.УстановитьПараметр("ЗапросКоммерческогоПредложения", ЗапросКоммерческогоПредложения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(ДанныеЗапроса, Выборка);
		
	КонецЦикла;
	
	Возврат ДанныеЗапроса;
	
КонецФункции

// Возвращает ссылку на учетный документ Запрос коммерческих предложений от клиента по идентификатору сервиса.
//
// Параметры:
//  Идентификатор - Строка - Идентификатор Запроса коммерческих предложений в сервисе.
// 
// Возвращаемое значение:
//  ДокументСсылка, Неопределено - Если документ найден, будет возвращена ссылка
//    (см. ОпределяемыйТип.ЗапросКоммерческогоПредложенияОтКлиента), иначе - Неопределено.
//
Функция ЗапросКоммерческихПредложенийОтКлиентаПоИдентификаторуСервиса(Знач Идентификатор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗапросКоммерческогоПредложенияОтКлиента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗапросКоммерческогоПредложенияОтКлиента КАК ЗапросКоммерческогоПредложенияОтКлиента
	|ГДЕ
	|	ЗапросКоммерческогоПредложенияОтКлиента.ИдентификаторСервиса = &Идентификатор";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Результат = Запрос.Выполнить();
	
	ЗапросКоммерческихПредложенийОтКлиента = Неопределено;
	
	Если Не Результат.Пустой() Тогда
		ЗапросКоммерческихПредложенийОтКлиента = Результат.Выгрузить()[0].Ссылка;
	КонецЕсли;
	
	Возврат ЗапросКоммерческихПредложенийОтКлиента;
	
КонецФункции

// Возвращает ссылку на учетный документ Запрос коммерческих предложений от клиента по идентификатору сервиса.
//
// Параметры:
//  ЗапросКоммерческогоПредложения - ДокументСсылка - ссылка на документ-основание.
//  ИдентификаторСтрокиЗапроса - Строка - идентификатор строки запроса.
// 
// Возвращаемое значение:
//  Структура, Неопределено - Если найдено, Структуру - см. описание конструктора НовыйДанныеСтрокиЗапроса(), иначе - Неопределено.
//
Функция ДанныеСтрокиЗапросаПоИдентификаторуСтрокиЗапроса(Знач ЗапросКоммерческогоПредложения, Знач ИдентификаторСтрокиЗапроса) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.НомерСтрокиЗапроса КАК НомерСтрокиЗапроса,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.ИдентификаторДляСопоставленияНоменклатуры КАК ИдентификаторДляСопоставленияНоменклатуры,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.ИдентификаторСтрокиЗапроса КАК ИдентификаторСтрокиЗапроса,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.НоменклатураСсылка КАК НоменклатураСсылка,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.ХарактеристикаСсылка КАК ХарактеристикаСсылка,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.НоменклатураПокупателяПредставление КАК НоменклатураПокупателяПредставление,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.НоменклатураПокупателяИдентификатор КАК НоменклатураПокупателяИдентификатор,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.НоменклатураВСервисеИдентификатор КАК НоменклатураВСервисеИдентификатор,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.ХарактеристикаВСервисеИдентификатор КАК ХарактеристикаВСервисеИдентификатор,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.Количество КАК Количество,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.МаксимальнаяЦена КАК МаксимальнаяЦена,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.СрокПоставки КАК СрокПоставки,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.СнятСРассмотрения КАК СнятСРассмотрения
	|ИЗ
	|	Документ.ЗапросКоммерческогоПредложенияОтКлиента.Товары КАК ЗапросКоммерческогоПредложенияОтКлиентаТовары
	|ГДЕ
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.Ссылка = &ЗапросКоммерческогоПредложения
	|	И ЗапросКоммерческогоПредложенияОтКлиентаТовары.ИдентификаторСтрокиЗапроса = &ИдентификаторСтрокиЗапроса";
	
	Запрос.УстановитьПараметр("ЗапросКоммерческогоПредложения", ЗапросКоммерческогоПредложения);
	Запрос.УстановитьПараметр("ИдентификаторСтрокиЗапроса", ИдентификаторСтрокиЗапроса);
	
	Результат = Запрос.Выполнить();
	
	ДанныеСтрокиЗапроса = Неопределено;
	
	Если Не Результат.Пустой() Тогда
		ДанныеСтрокиЗапроса = НовыйДанныеСтрокиЗапроса();
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиЗапроса, Результат.Выгрузить()[0]);
	КонецЕсли;
	
	Возврат ДанныеСтрокиЗапроса;
	
КонецФункции


#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.
Процедура ПриОпределенииСоставаКомандЭДО(СоставКоманд) Экспорт
	
	СоставКоманд.Входящие.Добавить("Документ.ЗапросКоммерческогоПредложенияОтКлиента");
	СоставКоманд.БезПодписи.Добавить("Документ.ЗапросКоммерческогоПредложенияОтКлиента");
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыЭлектронногоДокумента(Источник, Параметры) Экспорт
	
	ТипИсточника = ТипЗнч(Источник);
	
	Если Метаданные.ОпределяемыеТипы.ЗапросКоммерческогоПредложенияОтКлиента.Тип.СодержитТип(ТипИсточника) Тогда
		ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Источник, "Организация, Контрагент");
		Организация     = ДанныеДокумента.Организация;
		Контрагент      = ДанныеДокумента.Контрагент;
	ИначеЕсли Метаданные.ОпределяемыеТипы.ЗапросКоммерческогоПредложенияОтКлиентаОбъект.Тип.СодержитТип(ТипИсточника) Тогда
		Организация = Источник.Организация;
		Контрагент  = Источник.Контрагент;
	Иначе
		Возврат;
	КонецЕсли;
	
	Параметры.Вставить("Тип",         Перечисления.ТипыДокументовЭДО.ЗапросКоммерческихПредложений);
	Параметры.Вставить("Направление", Перечисления.НаправленияЭДО.Входящий);
	Параметры.Вставить("Организация",   Организация);
	Параметры.Вставить("Контрагент",    Контрагент);
	
КонецПроцедуры
// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьФайлыДляИзменения(ТаблицаИменФайлов, ВладелецФайлов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ 
		|	ТаблицаИменФайлов.ИмяБезРасширения КАК ИмяБезРасширения
		|ПОМЕСТИТЬ ТаблицаИменФайлов
		|ИЗ
		|	&ТаблицаИменФайлов КАК ТаблицаИменФайлов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаИменФайлов.ИмяБезРасширения КАК ИмяБезРасширения,
		|	ЕСТЬNULL(ЗапросКоммерческогоПредложенияОтКлиентаПрисоединенныеФайлы.Ссылка, НЕОПРЕДЕЛЕНО) КАК СсылкаНаФайл,
		|	ВЫБОР
		|		КОГДА ТаблицаИменФайлов.ИмяБезРасширения ЕСТЬ NULL
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПометкаУдаления
		|ИЗ
		|	ТаблицаИменФайлов КАК ТаблицаИменФайлов
		|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.ЗапросКоммерческогоПредложенияОтКлиентаПрисоединенныеФайлы КАК ЗапросКоммерческогоПредложенияОтКлиентаПрисоединенныеФайлы
		|		ПО ((ВЫРАЗИТЬ(ТаблицаИменФайлов.ИмяБезРасширения КАК СТРОКА(1024))) = (ВЫРАЗИТЬ(ЗапросКоммерческогоПредложенияОтКлиентаПрисоединенныеФайлы.Наименование КАК СТРОКА(1024))))
		|			И (ЗапросКоммерческогоПредложенияОтКлиентаПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла)";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайлов);
	Запрос.УстановитьПараметр("ТаблицаИменФайлов", ТаблицаИменФайлов);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПечатьЗапросаКоммерческихПредложений(МассивОбъектов, ОбъектыПечати)
	
	// Создаем табличный документ и устанавливаем имя параметров печати.
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ЗапросКоммерческихПредложенийПоставщиков";
	// Получаем запросом необходимые данные.
	
	Макет = Документы.ЗапросКоммерческогоПредложенияОтКлиента.ПолучитьМакет("ПФ_MXL_ЗапросНаКоммерческоеПредложение");
	
	ОбластьШтрихкода                = Макет.ПолучитьОбласть("ОбластьШтрихкода");
	ОбластьЗаголовок                = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПредложение              = Макет.ПолучитьОбласть("Предложение");
	ОбластьШапкаТаблицыТовары       = Макет.ПолучитьОбласть("ШапкаТаблицыТоварыЦена");
	ОбластьСтрокаТаблицыТовары      = Макет.ПолучитьОбласть("СтрокаТаблицыТоварыЦена");
	ОбластьПустаяСтрокаТонкая       = Макет.ПолучитьОбласть("ПустаяСтрокаТонкая");
	ОбластьДополнительнаяИнформация = Макет.ПолучитьОбласть("ДополнительнаяИнформация");
	ОбластьКонтактнаяИнформация     = Макет.ПолучитьОбласть("КонтактнаяИнформацияЗаявки");
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗапросКоммерческогоПредложенияОтКлиента.Организация КАК Организация,
	|	ЗапросКоммерческогоПредложенияОтКлиента.Менеджер.Наименование КАК МенеджерПредставление,
	|	ЗапросКоммерческогоПредложенияОтКлиента.УсловиеДоставкиТекст КАК УсловиеПоставкиТекст,
	|	ЗапросКоммерческогоПредложенияОтКлиента.УсловияОплатыТекст КАК УсловияОплатыТекст,
	|	ЗапросКоммерческогоПредложенияОтКлиента.ПрочаяДополнительнаяИнформацияТекст КАК ПрочаяДополнительнаяИнформацияТекст,
	|	ЗапросКоммерческогоПредложенияОтКлиента.Ссылка КАК Ссылка,
	|	ЗапросКоммерческогоПредложенияОтКлиента.НомерЭД КАК Номер,
	|	ЗапросКоммерческогоПредложенияОтКлиента.ДатаЭД КАК Дата
	|ИЗ
	|	Документ.ЗапросКоммерческогоПредложенияОтКлиента КАК ЗапросКоммерческогоПредложенияОтКлиента
	|ГДЕ
	|	ЗапросКоммерческогоПредложенияОтКлиента.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.Ссылка КАК Ссылка,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.Количество КАК Количество,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.МаксимальнаяЦена КАК Цена,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.СрокПоставки КАК СрокПоставки,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.НомерСтроки КАК НомерСтроки,
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.НоменклатураПокупателяПредставление КАК Номенклатура
	|ИЗ
	|	Документ.ЗапросКоммерческогоПредложенияОтКлиента.Товары КАК ЗапросКоммерческогоПредложенияОтКлиентаТовары
	|ГДЕ
	|	ЗапросКоммерческогоПредложенияОтКлиентаТовары.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Пакет = Запрос.ВыполнитьПакет();
	Шапка = Пакет[0].Выбрать();
	
	Товары = Пакет[1].Выгрузить();
	Товары.Индексы.Добавить("Ссылка");
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
		
		КоммерческиеПредложенияДокументыПереопределяемый.ПриВыводеШтриховогоКодаВПечатныеФормы(ТабличныйДокумент, Макет, ОбластьШтрихкода, Шапка);
		
		Сведения = ОбщегоНазначенияБЭД.ДанныеЮрФизЛица(Шапка.Организация);
		Сведения.Вставить("Организация", Шапка.Организация);
		Сведения.Вставить("ПредставлениеОрганизации", ?(ПустаяСтрока(Сведения.ПолноеНаименование),
			Сведения.Наименование, Сведения.ПолноеНаименование));
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		
		ЗаполнитьЗначенияСвойств(ОбластьЗаголовок.Параметры, Шапка);
		ОбластьЗаголовок.Параметры.АдресОрганизации = Сведения.ЮридическийАдрес;
		ОбластьЗаголовок.Параметры.ПредставлениеОрганизации = Сведения.ПредставлениеОрганизации;
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		ЗаполнитьЗначенияСвойств(ОбластьПредложение.Параметры, Шапка);
		ОбластьПредложение.Параметры.ПредставлениеОрганизации = Сведения.ПредставлениеОрганизации;
		ТабличныйДокумент.Вывести(ОбластьПредложение);
		
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицыТовары);
		
		Отбор = Новый Структура("Ссылка", Шапка.Ссылка);
		НайденныеСтроки = Товары.НайтиСтроки(Отбор);
		
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
			
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаТаблицыТовары.Параметры, НайденнаяСтрока);
			
			Если ТипЗнч(НайденнаяСтрока.СрокПоставки) = Тип("Дата") Тогда
				ОбластьСтрокаТаблицыТовары.Параметры.СрокПоставки = Формат(НайденнаяСтрока.СрокПоставки,"ДЛФ=D");
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыТовары);
			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПустаяСтрокаТонкая);
		
		ОбластьДополнительнаяИнформация.Параметры.УсловияПоставкиПредставление = ПредставлениеУсловийПоставки(Шапка);
		ТабличныйДокумент.Вывести(ОбластьДополнительнаяИнформация);
		
		ОбластьКонтактнаяИнформация.Параметры.КонтактнаяИнформацияЗаявки = КонтактнаяИнформацияЗаявки(Сведения);
		ТабличныйДокумент.Вывести(ОбластьКонтактнаяИнформация);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати комплектов документов.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
		НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПредставлениеУсловийПоставки(ДанныеОбъекта)

	ПредставлениеУсловийПоставки = "";
	
	Если Не ПустаяСтрока(ДанныеОбъекта.УсловияОплатыТекст) Тогда
		УсловияОплаты = СтрШаблон(НСтр("ru = 'Оплата: %1'"), ДанныеОбъекта.УсловияОплатыТекст);
		ПредставлениеУсловийПоставки = УсловияОплаты;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ДанныеОбъекта.УсловиеПоставкиТекст) Тогда
		
		УсловияДоставки = СтрШаблон(НСтр("ru = 'Поставка: %1'"), ДанныеОбъекта.УсловиеПоставкиТекст);
		ПредставлениеУсловийПоставки = ПредставлениеУсловийПоставки 
		                              + ?(ПустаяСтрока(ПредставлениеУсловийПоставки), "", Символы.ПС)
		                              + УсловияДоставки;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ДанныеОбъекта.ПрочаяДополнительнаяИнформацияТекст) Тогда
		
		Если ПустаяСтрока(ПредставлениеУсловийПоставки) Тогда
			ПрочиеУсловия = ДанныеОбъекта.ПрочаяДополнительнаяИнформацияТекст;
		Иначе
			ПрочиеУсловия = СтрШаблон(НСтр("ru = 'Прочее: %1'"), ДанныеОбъекта.ПрочаяДополнительнаяИнформацияТекст);
		КонецЕсли;
		
		ПредставлениеУсловийПоставки = ПредставлениеУсловийПоставки 
		                              + ?(ПустаяСтрока(ПредставлениеУсловийПоставки), "", Символы.ПС)
		                              + ПрочиеУсловия;
		
	КонецЕсли;
	
	Возврат ПредставлениеУсловийПоставки;

КонецФункции

Функция КонтактнаяИнформацияЗаявки(ДанныеОбъекта)
	
	КонтактнаяИнформацияОрганизации = "";
	
	Если ЗначениеЗаполнено(ДанныеОбъекта.Организация) Тогда
		
		Если ДанныеОбъекта.Свойство("ЮридическийАдрес") И Не ПустаяСтрока(ДанныеОбъекта.ЮридическийАдрес) Тогда
			ПредставлениеАдресаОрганизации  = СтрШаблон(ШаблонПредставленияАдреса(), ДанныеОбъекта.ЮридическийАдрес);
			КонтактнаяИнформацияОрганизации = КонтактнаяИнформацияОрганизации + Символы.ПС +  ПредставлениеАдресаОрганизации;
		КонецЕсли;
		
		Если ДанныеОбъекта.Свойство("Телефоны") И Не ПустаяСтрока(ДанныеОбъекта.Телефоны) Тогда
			ПредставлениеТелефонаОрганизации = СтрШаблон(ШаблонПредставлениеТелефона(), ДанныеОбъекта.Телефоны);
			КонтактнаяИнформацияОрганизации = КонтактнаяИнформацияОрганизации + Символы.ПС + ПредставлениеТелефонаОрганизации;
		КонецЕсли;
		
		Если ДанныеОбъекта.Свойство("ЭлектроннаяПочта") И Не ПустаяСтрока(ДанныеОбъекта.ЭлектроннаяПочта) Тогда
			ПредставлениеАдресЭПОрганизации = СтрШаблон(ШаблонПредставлениеEmail(), ДанныеОбъекта.ЭлектроннаяПочта);
			КонтактнаяИнформацияОрганизации = КонтактнаяИнформацияОрганизации + Символы.ПС + ПредставлениеАдресЭПОрганизации;
		КонецЕсли;
		
		Если Не ПустаяСтрока(КонтактнаяИнформацияОрганизации) Тогда
			КонтактнаяИнформацияОрганизации = НСтр("ru = 'Контактная информация организации:'") + КонтактнаяИнформацияОрганизации;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонтактнаяИнформацияОрганизации;
	
КонецФункции

Функция ШаблонПредставленияАдреса()
	
	Возврат Символы.Таб + НСтр("ru = 'Адрес: %1.'");
	
КонецФункции

Функция ШаблонПредставлениеТелефона()
	
	Возврат Символы.Таб + НСтр("ru = 'Тел.: %1.'");
	
КонецФункции

Функция ШаблонПредставлениеEmail()
	
	Возврат Символы.Таб + НСтр("ru = 'Эл. почта: %1.'");
	
КонецФункции

Функция НовыйДанныеСтрокиЗапроса()
	
	ДанныеСтрокиЗапроса = Новый Структура();
	ДанныеСтрокиЗапроса.Вставить("НомерСтрокиЗапроса");
	ДанныеСтрокиЗапроса.Вставить("ИдентификаторДляСопоставленияНоменклатуры");
	ДанныеСтрокиЗапроса.Вставить("ИдентификаторСтрокиЗапроса");
	ДанныеСтрокиЗапроса.Вставить("НоменклатураСсылка");
	ДанныеСтрокиЗапроса.Вставить("ХарактеристикаСсылка");
	ДанныеСтрокиЗапроса.Вставить("НоменклатураПокупателяПредставление");
	ДанныеСтрокиЗапроса.Вставить("НоменклатураПокупателяИдентификатор");
	ДанныеСтрокиЗапроса.Вставить("НоменклатураВСервисеИдентификатор");
	ДанныеСтрокиЗапроса.Вставить("ХарактеристикаВСервисеИдентификатор");
	ДанныеСтрокиЗапроса.Вставить("ЕдиницаИзмерения");
	ДанныеСтрокиЗапроса.Вставить("Количество");
	ДанныеСтрокиЗапроса.Вставить("МаксимальнаяЦена");
	ДанныеСтрокиЗапроса.Вставить("СрокПоставки");
	ДанныеСтрокиЗапроса.Вставить("СнятСРассмотрения");
	
	Возврат ДанныеСтрокиЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли

