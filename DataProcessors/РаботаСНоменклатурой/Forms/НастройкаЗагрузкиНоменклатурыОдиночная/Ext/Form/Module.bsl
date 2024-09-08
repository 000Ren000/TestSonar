﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("НоменклатураДляАнализа", АдресДанныхНоменклатуры);
	
	Если НЕ ЗначениеЗаполнено(АдресДанныхНоменклатуры) 
		ИЛИ НЕ ЭтоАдресВременногоХранилища(АдресДанныхНоменклатуры) Тогда
		
		ВызватьИсключение НСтр("ru = 'Ошибка передачи данных номенклатуры'");
	КонецЕсли;
	
	ДанныеНоменклатуры = ПолучитьИзВременногоХранилища(АдресДанныхНоменклатуры);
	
	Если ДанныеНоменклатуры.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка передачи данных номенклатуры'");
	КонецЕсли;
	
	ТекущаяНоменклатура = ДанныеНоменклатуры[0];
	
	ЗаполнитьРеквизитыФормы(ТекущаяНоменклатура);
	
	НастроитьФормуПриСоздании();
	
	ЗаполнитьСписокВыбора(ТекущаяНоменклатура.Категория.ВидыНоменклатурыИнформационнойБазы);
	
	СформироватьПодсказкуКВидуНоменклатуры(ПараметрыДляПодсказкиКВидуНоменклатуры(),
		Элементы.ПояснениеКВидуНоменклатуры.Заголовок);
		
	ЭтоИнтерактивнаяЗагрузкаНоменклатуры = Не РаботаСНоменклатурой.РазрешеноПакетноеСозданиеНоменклатуры();
		
	Если ИспользуютсяХарактеристикиВСервисе
		 И РаботаСНоменклатурой.НастройкиПодсистемы().ИспользоватьХарактеристики Тогда
		 
		 СформироватьСписокВыбораХарактеристикИПодсказку();
	КонецЕсли;
			
	УстановитьЗаголовки();	
		
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	КлючСохраненияПоложенияОкна = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ВыбраныОбъектыДляЗагрузки() Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка номенклатуры'"),, НСтр("ru = 'Номенклатура не загружена'"));
		Закрыть();
	Иначе
		ЗагрузитьНоменклатуру();	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкаВнешнегоВидаФормы

&НаСервере
Процедура УстановитьЗаголовки()
	
	ЗаголовокФормы = НСтр("ru = 'Загрузка номенклатуры'");
	ЗаголовокЭлемента = "";
	
	Если Не ЗначениеЗаполнено(ВидНоменклатуры) И ИспользуютсяХарактеристикиВСервисе Тогда
		
		СтрокаЗаголовка = 
			СтрШаблон(
				НСтр("ru = 'Для номенклатуры <a href = ""Номенклатура"">%1</a> необходимо загрузить категорию
					|<a href = ""Категория"">%2</a> или сопоставить ее с видом номенклатуры. 
					|Это позволит сохранить дополнительные реквизиты и характеристики номенклатуры.'"), 
						НаименованиеНоменклатуры, НаименованиеКатегории);
							
	ИначеЕсли Не ЗначениеЗаполнено(ВидНоменклатуры) И Не ИспользуютсяХарактеристикиВСервисе Тогда
		
		СтрокаЗаголовка = 
			СтрШаблон(
				НСтр("ru = 'Для номенклатуры <a href = ""Номенклатура"">%1</a> необходимо загрузить 
					|категорию <a href = ""Категория"">%2</a> или сопоставить ее с видом номенклатуры.'"), 
						НаименованиеНоменклатуры, НаименованиеКатегории);
							
	ИначеЕсли ЗначениеЗаполнено(ВидНоменклатуры) И ИспользуютсяХарактеристикиВСервисе Тогда
		
		СтрокаЗаголовка = СтрШаблон(
			НСтр("ru = 'Для номенклатуры <a href = ""Номенклатура"">%1</a> ведутся характеристики. 
				|Выберите характеристики для загрузки.'"), 
					НаименованиеНоменклатуры)
		
	КонецЕсли;
	
	Заголовок = ЗаголовокФормы;
	Элементы.ПояснениеКФорме.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		СтрЗаменить(СтрокаЗаголовка, Символы.ПС , " "));
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НастроитьФормуПриДлительнойОперации(ЭтоНачалоДлительнойОперации, Режим)
	
	Если Режим = "ВидНоменклатуры" Тогда
		Элементы.ПояснениеКВидуНоменклатуры.Заголовок = НСтр("ru = 'Создание вида номенклатуры...'");
		Элементы.КартинкаДлительнойОперацииКатегория.Видимость = ЭтоНачалоДлительнойОперации;
	Иначе
		Элементы.ГруппаДекорацииДлительнойОперации.Видимость = ЭтоНачалоДлительнойОперации;	
	КонецЕсли;
	
	Элементы.ВидНоменклатуры.Доступность = Не ЭтоНачалоДлительнойОперации;
	Элементы.Создать.Доступность         = Не ЭтоНачалоДлительнойОперации;
	Элементы.Характеристики.Доступность  = Не ЭтоНачалоДлительнойОперации;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоличествоРеквизитов()
	
	ДанныеПоНоменклатуре = ПолучитьИзВременногоХранилища(АдресДанныхНоменклатуры);
	
	СтрокаНоменклатуры = ДанныеПоНоменклатуре.Найти(ИдентификаторКатегории, "ИдентификаторКатегории");
	
	Если СтрокаНоменклатуры = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
	СоответствиеРеквизитовИЗначений = Неопределено;
		
	ПодсчитатьКоличествоДополнительныхРеквизитов(СтрокаНоменклатуры);
	
	ВсеРеквизитыСопоставлены 
		= КоличествоДополнительныхРеквизитов = КоличествоСопоставленныхРеквизитов;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокВыбораХарактеристикИПодсказку()
	
	СформироватьСписокВыбораХарактеристик(ПараметрыДляСпискаВыбораХарактеристик(), Элементы.Характеристики.СписокВыбора);
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) И КоличествоВыбранныхХарактеристик = 0 Тогда
		Характеристики = Элементы.Характеристики.СписокВыбора[1].Значение;
	ИначеЕсли Не ЗначениеЗаполнено(ВидНоменклатуры) И КоличествоВыбранныхХарактеристик = 0 Тогда	
		Характеристики = Элементы.Характеристики.СписокВыбора[0].Значение;
	КонецЕсли;
	
	СформироватьПодсказкуКХарактеристикам(ПараметрыДляПодсказкиХарактеристик(), Элементы.ПоясненияКХарактеристикам.Заголовок)
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПодсказкуКВидуНоменклатуры(Данные, РеквизитХраненияПодсказки)
	
	РаботаСНоменклатурой.СформироватьПодсказкуКВидуНоменклатуры(Данные, РеквизитХраненияПодсказки);
	
	Элементы.ПояснениеКВидуНоменклатуры.Гиперссылка 
		= ВидНоменклатурыСопоставлен И КоличествоДополнительныхРеквизитов <> КоличествоСопоставленныхРеквизитов;

	Если Элементы.ПояснениеКВидуНоменклатуры.Гиперссылка Тогда
		Элементы.ПояснениеКВидуНоменклатуры.ЦветТекста = ЦветаСтиля.ГиперссылкаЦвет;
	Иначе
		Элементы.ПояснениеКВидуНоменклатуры.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбора(ВидыНоменклатурыИнформационнойБазы)
	
	СписокВыбора = Элементы.ВидНоменклатуры.СписокВыбора;
	
	Для каждого ЭлементКоллекции Из ВидыНоменклатурыИнформационнойБазы Цикл
		СписокВыбора.Добавить(ЭлементКоллекции, , , БиблиотекаКартинок.Реквизит);
	КонецЦикла;
	
	РаботаСНоменклатурой.ЗаполнитьВидыНоменклатурыПоСтрокеПоиска(СписокВыбора, НаименованиеКатегории);
	
	Если ВидыНоменклатурыИнформационнойБазы.Количество() = 0 Тогда
		СоздатьВидНоменклатуры = Новый ФорматированнаяСтрока(НСтр("ru = 'Создать вид номенклатуры'"),,,,"СоздатьВидНоменклатуры");
		СписокВыбора.Добавить("СоздатьВидНоменклатуры", СоздатьВидНоменклатуры,, БиблиотекаКартинок.ИконкаБелыйФонРаботаСНоменклатурой);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНоменклатуру()
	
	НастроитьФормуПриДлительнойОперации(Истина, "Номенклатура");
	
	Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		Новый Структура("ИдентификаторНоменклатуры, ИдентификаторХарактеристики", ИдентификаторНоменклатуры, ""));
		
	ДополнительныеПараметрыСоздания = Новый Соответствие;	
	
	ПодготовитьПараметрыСозданияНоменклатуры(ДополнительныеПараметрыСоздания);
	
	ПараметрыОповещения = Новый Структура;
	
	Если ЭтоИнтерактивнаяЗагрузкаНоменклатуры Тогда
		ПараметрыОповещения.Вставить("ИсходноеОписаниеОповещения", ОписаниеОповещенияОЗакрытии);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьНоменклатуруПродолжение", ЭтотОбъект, ПараметрыОповещения);
	
	РаботаСНоменклатуройКлиент.ЗагрузитьНоменклатуруИХарактеристики(
		Оповещение, 
		Идентификаторы, 
		ЭтотОбъект, 
		ДополнительныеПараметрыСоздания, 
		Неопределено, 
		Элементы.ГруппаДекорацииДлительнойОперации);
		
КонецПроцедуры

&НаКлиенте
Функция ВыбраныОбъектыДляЗагрузки()
	
	Возврат Не (СтатусВеденияУчетаХарактеристик = "НеВедутся"
		И ИспользуютсяХарактеристикиВСервисе 
		И Характеристики = "ВыбранныеХарактеристики"
		И КоличествоВыбранныхХарактеристик = 0);
			
КонецФункции

&НаСервере
Процедура ПодготовитьПараметрыСозданияНоменклатуры(ДополнительныеПараметрыСоздания)
			
	ДополнительныеПараметры = РаботаСНоменклатуройСлужебныйКлиентСервер.ДополнительныеПараметрыЗагрузкиНоменклатуры();
	
	ДополнительныеПараметры.ВидНоменклатуры = ВидНоменклатуры;	
	
	Если ИспользуютсяХарактеристикиВСервисе Тогда
		
		ДополнительныеПараметры.ХарактеристикиВыбраны      = Истина;
		ДополнительныеПараметры.ЗагружатьВсеХарактеристики = Характеристики = "ВсеХарактеристики";
		
		Если ЗначениеЗаполнено(АдресВыбранныхХарактеристик) Тогда
			ДополнительныеПараметры.ВыбранныеХарактеристики = ПолучитьИзВременногоХранилища(АдресВыбранныхХарактеристик);
		КонецЕсли;
		
		Если Характеристики = "БезХарактеристик" Тогда
			ДополнительныеПараметры.РежимЗагрузкиХарактеристик = "НеЗагружать";
		Иначе
			Если СтатусВеденияУчетаХарактеристик <> "НеВедутся" Тогда		
				ДополнительныеПараметры.РежимЗагрузкиХарактеристик = "ВХарактеристики";
			Иначе
				ДополнительныеПараметры.РежимЗагрузкиХарактеристик = "ВДополнительныеРеквизиты";
			КонецЕсли;	
		КонецЕсли;
				
	Иначе 
		ДополнительныеПараметры.РежимЗагрузкиХарактеристик = "НеЗагружать";
	КонецЕсли;
	
	ДополнительныеПараметрыСоздания.Вставить(ИдентификаторНоменклатуры, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНоменклатуруПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Открыта() Тогда
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы(ТекущаяНоменклатура)
	
	Статусы = РаботаСНоменклатурой.СтатусыПроверкиНоменклатуры();
		
	ИдентификаторКатегории     = ТекущаяНоменклатура.Категория.Идентификатор;
	НаименованиеКатегории      = ТекущаяНоменклатура.Категория.Наименование;
	ИдентификаторНоменклатуры  = ТекущаяНоменклатура.Идентификатор;
	НаименованиеНоменклатуры   = ТекущаяНоменклатура.Наименование;
	
	ПодсчитатьКоличествоДополнительныхРеквизитов(ТекущаяНоменклатура);
	
	ВсеРеквизитыСопоставлены 
		= КоличествоДополнительныхРеквизитов = КоличествоСопоставленныхРеквизитов;
	
	Если ТекущаяНоменклатура.Категория.ВидыНоменклатурыИнформационнойБазы.Количество() = 1 Тогда
		ВидНоменклатуры = ТекущаяНоменклатура.Категория.ВидыНоменклатурыИнформационнойБазы[0];		
		СтатусВеденияУчетаХарактеристик = РаботаСНоменклатурой.ВариантИспользованияХарактеристик(ВидНоменклатуры);
	КонецЕсли;
	
	ВидНоменклатурыСопоставлен = ВидНоменклатурыСопоставленСКатегорией(ВидНоменклатуры, ИдентификаторКатегории);
	
	ИспользуютсяХарактеристикиВСервисе = ТекущаяНоменклатура.КоличествоХарактеристик > 0;
	КоличествоХарактеристик            = ТекущаяНоменклатура.КоличествоХарактеристик 
		- РаботаСНоменклатурой.КоличествоСопоставленныхХарактеристикПоИдентификатору(ИдентификаторНоменклатуры);
	
	Если ЗначениеЗаполнено(ТекущаяНоменклатура.ВыбранныеХарактеристики) Тогда
		
		// Если в момент загрузки были выбраны характеристики - они будут отмечены.
		
		АдресВыбранныхХарактеристик = ПоместитьВоВременноеХранилище(
			ТекущаяНоменклатура.ВыбранныеХарактеристики, ЭтотОбъект.УникальныйИдентификатор);
		КоличествоВыбранныхХарактеристик = ТекущаяНоменклатура.ВыбранныеХарактеристики.Количество();
		Характеристики = "ВыбранныеХарактеристики";
	КонецЕсли;
	
	ВидыНоменклатурыКатегории.ЗагрузитьЗначения(ТекущаяНоменклатура.Категория.ВидыНоменклатурыИнформационнойБазы);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПриСоздании()
	
	ПоказыватьХарактеристики = ИспользуютсяХарактеристикиВСервисе И РаботаСНоменклатурой.НастройкиПодсистемы().ИспользоватьХарактеристики;
	
	Элементы.ГруппаВидНоменклатуры.Видимость     = ВидыНоменклатурыКатегории.Количество() <> 1;
	Элементы.Характеристики.Видимость            = ПоказыватьХарактеристики;
	Элементы.ПоясненияКХарактеристикам.Видимость = ПоказыватьХарактеристики;
	
	Элементы.КартинкаДлительнойОперацииКатегория.Видимость = Ложь;
	Элементы.ГруппаДекорацииДлительнойОперации.Видимость   = Ложь;
				
КонецПроцедуры

&НаСервере
Процедура ПодсчитатьКоличествоДополнительныхРеквизитов(ТекущаяНоменклатура)
	
	РаботаСНоменклатурой.ПодсчитатьКоличествоДополнительныхРеквизитов(ТекущаяНоменклатура, ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьСписокВыбораХарактеристик(Данные, СписокВыбораХарактеристик)
	
	РаботаСНоменклатуройСлужебныйКлиентСервер.СформироватьСписокВыбораХарактеристик(Данные, СписокВыбораХарактеристик);

КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПриИзменении(Элемент)
	
	Если Характеристики = "ВыбранныеХарактеристики" Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораХарактеристик", ЭтотОбъект);
		
		РаботаСНоменклатуройКлиент.ОткрытьФормуПодбораХарактеристик(ИдентификаторНоменклатуры,
			АдресДанныхНоменклатуры, АдресВыбранныхХарактеристик, Ложь, ЭтотОбъект, Оповещение);
				
	КонецЕсли;
		
	СформироватьПодсказкуКХарактеристикам(ПараметрыДляПодсказкиХарактеристик(), 
		Элементы.ПоясненияКХарактеристикам.Заголовок);		
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораХарактеристик(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	АдресВыбранныхХарактеристик      = Результат.АдресВыбранныхХарактеристик;
	КоличествоВыбранныхХарактеристик = Результат.КоличествоВыбранныхХарактеристик;
	
	СформироватьСписокВыбораХарактеристик(ПараметрыДляСпискаВыбораХарактеристик(), Элементы.Характеристики.СписокВыбора);
	
	СформироватьПодсказкуКХарактеристикам(ПараметрыДляПодсказкиХарактеристик(), 
		Элементы.ПоясненияКХарактеристикам.Заголовок);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыДляСпискаВыбораХарактеристик()
	
	ПараметрыМетода = Новый Структура;
	
	ПараметрыМетода.Вставить("КоличествоХарактеристик",              КоличествоХарактеристик);
	ПараметрыМетода.Вставить("КоличествоВыбранныхХарактеристик",     КоличествоВыбранныхХарактеристик);
	ПараметрыМетода.Вставить("ВсеРеквизитыСопоставлены",             ВсеРеквизитыСопоставлены);
	ПараметрыМетода.Вставить("ИспользуютсяХарактеристикиВСервисе",   ИспользуютсяХарактеристикиВСервисе);
	ПараметрыМетода.Вставить("СтатусВеденияУчетаХарактеристик",      СтатусВеденияУчетаХарактеристик);
	
	Возврат ПараметрыМетода;
		
КонецФункции

&НаСервере
Функция ПараметрыДляПодсказкиХарактеристик()
	
	ПараметрыМетода = Новый Структура;
	
	ПараметрыМетода.Вставить("ВсеРеквизитыСопоставлены",             ВсеРеквизитыСопоставлены);
	ПараметрыМетода.Вставить("ИспользуютсяХарактеристикиВСервисе",   ИспользуютсяХарактеристикиВСервисе);
	ПараметрыМетода.Вставить("КоличествоХарактеристик",              КоличествоХарактеристик);
	ПараметрыМетода.Вставить("КоличествоВыбранныхХарактеристик",     КоличествоВыбранныхХарактеристик);
	ПараметрыМетода.Вставить("РежимЗагрузкиХарактеристик",           Характеристики);
	ПараметрыМетода.Вставить("СтатусВеденияУчетаХарактеристик",      СтатусВеденияУчетаХарактеристик);

	Возврат ПараметрыМетода;
	
КонецФункции

&НаСервере
Функция ПараметрыДляПодсказкиКВидуНоменклатуры()
	
	ПараметрыМетода = Новый Структура;
	
	ПараметрыМетода.Вставить("ВидНоменклатуры",                    ВидНоменклатуры);
	ПараметрыМетода.Вставить("ИдентификаторКатегории",             ИдентификаторКатегории);
	ПараметрыМетода.Вставить("НаименованиеКатегории",              НаименованиеКатегории);
	ПараметрыМетода.Вставить("СтатусВеденияУчетаХарактеристик",    СтатусВеденияУчетаХарактеристик);
	ПараметрыМетода.Вставить("КоличествоСопоставленныхРеквизитов", КоличествоСопоставленныхРеквизитов);
	ПараметрыМетода.Вставить("КоличествоДополнительныхРеквизитов", КоличествоДополнительныхРеквизитов);
	ПараметрыМетода.Вставить("ИспользуютсяХарактеристикиВСервисе", ИспользуютсяХарактеристикиВСервисе);
	ПараметрыМетода.Вставить("ВидыНоменклатурыКатегории",          ВидыНоменклатурыКатегории);
	ПараметрыМетода.Вставить("ВидНоменклатурыСопоставлен",         ВидНоменклатурыСопоставлен);

	Возврат ПараметрыМетода;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьПодсказкуКХарактеристикам(Данные, РеквизитХраненияПодсказки)
	
	РаботаСНоменклатуройСлужебныйКлиентСервер.СформироватьПодсказкуКХарактеристикам(Данные, РеквизитХраненияПодсказки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеКВидуНоменклатурыНажатие(Элемент)
	
	Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуЗаполненияВидаНоменклатуры(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗаполненияВидаНоменклатуры(ЭтоРежимСопоставленияРеквизитов)
	
	Идентификаторы = Новый СписокЗначений;
	
	Идентификаторы.Добавить(ИдентификаторКатегории, НаименованиеКатегории);
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ВидНоменклатуры",                 ВидНоменклатуры);
	ПараметрыФормы.Вставить("ИдентификаторыКатегорий",         Идентификаторы);
	ПараметрыФормы.Вставить("ЭтоРежимСопоставленияРеквизитов", ЭтоРежимСопоставленияРеквизитов);
	ПараметрыФормы.Вставить("ЭтоВнешняяПривязка",              Истина);
	
	Оповещение = Новый ОписаниеОповещения("ПослеСопоставленияРеквизитов", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.РаботаСНоменклатурой.Форма.ЗаполнениеВидаНоменклатуры", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеСопоставленияРеквизитов(Результат, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииВидаНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеПоВидуНоменклатуры()
	
	Элементы.ПояснениеКВидуНоменклатуры.Заголовок  = "";
	КоличествоДополнительныхРеквизитов             = 0;
	КоличествоСопоставленныхРеквизитов             = 0;
	СтатусВеденияУчетаХарактеристик                = "";

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВидаНоменклатуры()
	
	ОчиститьДанныеПоВидуНоменклатуры();
	
	Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
		
	ВидНоменклатурыСопоставлен 
		= ВидНоменклатурыСопоставленСКатегорией(ВидНоменклатуры, ИдентификаторКатегории);
		
	Если ВидНоменклатурыСопоставлен
		И ВидыНоменклатурыКатегории.НайтиПоЗначению(ВидНоменклатуры) = Неопределено Тогда
			
		ВидыНоменклатурыКатегории.Вставить(0, ВидНоменклатуры);
	КонецЕсли;	
		
	ЗаполнитьКоличествоРеквизитов();
	
	Если ВсеРеквизитыСопоставлены 
		И Характеристики <> "ВыбранныеХарактеристики" Тогда
		
		Характеристики = "ВсеХарактеристики";
	КонецЕсли;		
	
	ПолучитьВариантИспользованияХарактеристик();	
	
	СформироватьПодсказкуКВидуНоменклатуры(ПараметрыДляПодсказкиКВидуНоменклатуры(),
		Элементы.ПояснениеКВидуНоменклатуры.Заголовок);
		
	СформироватьСписокВыбораХарактеристик(ПараметрыДляСпискаВыбораХарактеристик(), 
		Элементы.Характеристики.СписокВыбора);	
	
	СформироватьПодсказкуКХарактеристикам(ПараметрыДляПодсказкиХарактеристик(), 
		Элементы.ПоясненияКХарактеристикам.Заголовок);		
				
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если ВыбранноеЗначение = "СоздатьВидНоменклатуры" Тогда
		СтандартнаяОбработка = Ложь;
		СоздатьВидНоменклатуры();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВидНоменклатуры()
	
	НастроитьФормуПриДлительнойОперации(Истина, "ВидНоменклатуры");
	
	Идентификаторы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		Новый Структура("Идентификатор, КоличествоПодчиненных", ИдентификаторКатегории, 0));
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания", Неопределено);
	ПараметрыЗавершения.Вставить("КатегорииКЗагрузке",   Идентификаторы);
	
	ЗагрузитьКатегорииЗавершение = Новый ОписаниеОповещения("ЗагрузитьКатегорииЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
	
	РаботаСНоменклатуройКлиент.ЗагрузитьКатегории(
		ЗагрузитьКатегорииЗавершение, 
		Идентификаторы, 
		ЭтотОбъект, 
		Неопределено, 
		Элементы.КартинкаДлительнойОперацииКатегория);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКатегорииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	НастроитьФормуПриДлительнойОперации(Ложь, "ВидНоменклатуры");
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для каждого Сообщение Из Результат.Сообщения Цикл
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Ошибка = Ложь;
	
	Если ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда 
		РезультатЗагрузки = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатЗагрузки = Неопределено Тогда 
			Ошибка = Истина;
		КонецЕсли;
	Иначе
		Ошибка = Истина;
	КонецЕсли;
	
	Если Ошибка Тогда 
		
		КартинкаОповещения = БиблиотекаКартинок.Ошибка32;
		ТекстОповещения = НСтр("ru = 'Создать не удалось'");
		
	Иначе
		
		Если РезультатЗагрузки.НовыеЭлементы.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;	
			
		НовыеЭлементы = ВидыНоменклатурыИзРезультатаСоздания(РезультатЗагрузки.НовыеЭлементы);
		
		КартинкаОповещения = БиблиотекаКартинок.Успешно32;
		
		ТекстОповещения = СтрШаблон(НСтр("ru = 'Создан вид номенклатуры ""%1""'"), НовыеЭлементы[0]);
		
		ВидНоменклатуры = НовыеЭлементы[0];
		
		Элементы.ВидНоменклатуры.СписокВыбора.Вставить(0, НовыеЭлементы[0]);
		
		ВидыНоменклатурыКатегории.Добавить(ВидНоменклатуры);
		
		ПриИзмененииВидаНоменклатуры();
		
		Оповестить(РаботаСНоменклатуройКлиент.ОписаниеОповещенийПодсистемы().ЗагрузкаКатегорий, НовыеЭлементы);
			
	КонецЕсли;
		
	ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка категорий'"),,
		ТекстОповещения, КартинкаОповещения, СтатусОповещенияПользователя.Информация, УникальныйИдентификатор);		
				
КонецПроцедуры

&НаКлиенте
Функция ВидыНоменклатурыИзРезультатаСоздания(НовыеЭлементы)
	
	Результат = Новый Массив;
	
	Для каждого ЭлементКоллекции Из НовыеЭлементы Цикл
		Результат.Добавить(ЭлементКоллекции.ВидНоменклатуры);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ПриИзмененииВидаНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьВариантИспользованияХарактеристик()
	
	Если НЕ ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Возврат;
	КонецЕсли;	
	
	СтатусВеденияУчетаХарактеристик = РаботаСНоменклатурой.ВариантИспользованияХарактеристик(ВидНоменклатуры);
		
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВидаНоменклатуры", ЭтотОбъект);
	
	ИмяФормыВидаНоменклатуры = РаботаСНоменклатуройСлужебныйВызовСервера.ИмяФормыЭлементаВидаНоменклатуры();
	
	Если НЕ ЗначениеЗаполнено(ИмяФормыВидаНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыВидаНоменклатуры, Новый Структура("Ключ", ВидНоменклатуры), ЭтотОбъект,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВидаНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииВидаНоменклатуры();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидНоменклатурыСопоставленСКатегорией(ВидНоменклатуры, ИдентификаторКатегории)
	
	Идентификаторы = РаботаСНоменклатурой.ПолучитьСоответствиеВидовНоменклатурыПоСсылкам(ВидНоменклатуры);
	
	Возврат Идентификаторы.Найти(ИдентификаторКатегории, "ИдентификаторКатегории") <> Неопределено;
		
КонецФункции

&НаКлиенте
Процедура ПояснениеКФормеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Номенклатура" Тогда
		РаботаСНоменклатуройКлиент.ОткрытьФормуКарточкиНоменклатуры(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторНоменклатуры), ЭтотОбъект);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Категория" Тогда
		РаботаСНоменклатуройКлиент.ОткрытьФормуКарточкиКатегории(ИдентификаторКатегории, Неопределено, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеКВидуНоменклатурыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Сопоставить" Тогда
		
		Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		
		ОткрытьФормуЗаполненияВидаНоменклатуры(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти